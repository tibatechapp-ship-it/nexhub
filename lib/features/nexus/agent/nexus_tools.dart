import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../shared/data/database.dart';
import '../../git/data/git_service.dart';


/// Resolve [relative] against [repoPath] and ensure the result stays inside
/// the repository. Returns null if the path escapes the repo root.
String? safePath(String repoPath, String relative) {
  // Reject absolute paths and empty/traversal attempts up front.
  if (relative.isEmpty) return null;
  if (relative.startsWith('/') || relative.startsWith('\\')) return null;
  // Normalize separators and reject any '..' segment.
  final normalized = relative.replaceAll('\\', '/');
  for (final seg in normalized.split('/')) {
    if (seg == '..' || seg == '.') return null;
  }
  final root = Directory(repoPath).absolute.path;
  final resolved = File('$root/$normalized').absolute.path;
  if (resolved != root && !resolved.startsWith('$root/')) {
    return null;
  }
  return resolved;
}

/// Tool definitions for the Nexus Agent (OpenAI function-calling schema).
class NexusTool {
  const NexusTool({
    required this.name,
    required this.description,
    required this.parameters,
    required this.execute,
  });
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final Future<String> Function(Map<String, dynamic> args) execute;

  Map<String, dynamic> toJson() => {
        'type': 'function',
        'function': {
          'name': name,
          'description': description,
          'parameters': parameters,
        },
      };
}

/// Build the list of tools available to the agent, given a repo path.
List<NexusTool> buildNexusTools({
  required String repoPath,
  required GitService git,
  AppDatabase? db,
}) {
  return [
    NexusTool(
      name: 'get_recent_commits',
      description:
          'Get the most recent commits in the repository. Use this to '
          'understand recent changes before explaining or reviewing.',
      parameters: {
        'type': 'object',
        'properties': {
          'limit': {
            'type': 'integer',
            'description': 'Number of commits to fetch (default 5, max 20).',
          },
        },
        'required': [],
      },
      execute: (args) async {
        final limit = (args['limit'] as int?)?.clamp(1, 20) ?? 5;
        final commits = await git.log(limit: limit);
        if (commits.isEmpty) return 'No commits found.';
        return commits
            .map((c) =>
                '${c.hash.substring(0, 8)} | ${c.author} | ${c.subject}')
            .join('\n');
      },
    ),
    NexusTool(
      name: 'get_commit_diff',
      description:
          'Get the diff (changed files and hunks) for a specific commit. '
          'Use this to explain what changed in a commit.',
      parameters: {
        'type': 'object',
        'properties': {
          'commit_hash': {
            'type': 'string',
            'description': 'Full or short commit hash.',
          },
        },
        'required': ['commit_hash'],
      },
      execute: (args) async {
        final hash = args['commit_hash'] as String;
        final diff = await git.commitDiff(hash);
        if (diff.isEmpty) return 'No diff available for $hash.';
        if (diff.length > 6000) {
          return '${diff.substring(0, 6000)}\n... (truncated)';
        }
        return diff;
      },
    ),
    NexusTool(
      name: 'read_file',
      description:
          'Read the content of a file in the repository. Use this to '
          'understand code before explaining or reviewing.',
      parameters: {
        'type': 'object',
        'properties': {
          'file_path': {
            'type': 'string',
            'description': 'Relative path within the repo.',
          },
        },
        'required': ['file_path'],
      },
      execute: (args) async {
        final path = args['file_path'] as String;
        final resolved = safePath(repoPath, path);
        if (resolved == null) return 'Access denied: path escapes repository.';
        final file = File(resolved);
        if (!await file.exists()) return 'File not found: $path';
        final content = await file.readAsString();
        if (content.length > 8000) {
          return '${content.substring(0, 8000)}\n... (truncated)';
        }
        return content;
      },
    ),
    NexusTool(
      name: 'list_files',
      description:
          'List files in a directory of the repository. Use this to '
          'explore the project structure.',
      parameters: {
        'type': 'object',
        'properties': {
          'dir_path': {
            'type': 'string',
            'description': 'Relative directory path (empty for root).',
          },
        },
        'required': [],
      },
      execute: (args) async {
        final dir = (args['dir_path'] as String?) ?? '';
        final resolved = safePath(repoPath, dir);
        if (resolved == null) return 'Access denied: path escapes repository.';
        final directory = Directory(resolved);
        if (!await directory.exists()) return 'Directory not found.';
        final entries = await directory.list().toList();
        final names = entries
            .map((e) => e.path.split('/').last +
                (e is Directory ? '/' : ''))
            .toList();
        if (names.isEmpty) return 'Empty directory.';
        return names.join('\n');
      },
    ),
    NexusTool(
      name: 'search_code',
      description:
          'Search for a keyword or text pattern across all files in the '
          'repository. Returns matching file paths and line numbers. '
          'Use this to find where a function, class, or variable is defined.',
      parameters: {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'The text or keyword to search for.',
          },
        },
        'required': ['query'],
      },
      execute: (args) async {
        final query = args['query'] as String;
        final results = <String>[];
        final dir = Directory(repoPath);
        await for (final entity in dir.list(recursive: true)) {
          if (entity is! File) continue;
          final path = entity.path;
          // Skip binary/generated files
          if (path.contains('/.git/') ||
              path.contains('/build/') ||
              path.endsWith('.g.dart') ||
              path.endsWith('.lock')) {
            continue;
          }
          try {
            final content = await entity.readAsString();
            final lines = content.split('\n');
            for (var i = 0; i < lines.length; i++) {
              if (lines[i].contains(query)) {
                final rel = path.replaceFirst('$repoPath/', '');
                results.add('$rel:${i + 1}: ${lines[i].trim()}');
                if (results.length >= 30) break;
              }
            }
          } catch (_) {
            // Skip unreadable files
          }
          if (results.length >= 30) break;
        }
        if (results.isEmpty) return 'No matches found for "$query".';
        return results.join('\n');
      },
    ),
    NexusTool(
      name: 'apply_patch',
      description:
          'Apply a code change to a file in the repository. Use this when '
          'the user asks to fix, modify, or create a file. The new_content '
          'replaces the entire file content.',
      parameters: {
        'type': 'object',
        'properties': {
          'file_path': {
            'type': 'string',
            'description': 'Relative path of the file to modify or create.',
          },
          'new_content': {
            'type': 'string',
            'description': 'The complete new content of the file.',
          },
          'summary': {
            'type': 'string',
            'description': 'Brief description of what changed and why.',
          },
        },
        'required': ['file_path', 'new_content', 'summary'],
      },
      execute: (args) async {
        final filePath = args['file_path'] as String;
        final newContent = args['new_content'] as String;
        final summary = args['summary'] as String;
        final resolved = safePath(repoPath, filePath);
        if (resolved == null) return 'Access denied: path escapes repository.';
        final file = File(resolved);
        try {
          // Ensure parent directory exists
          final parent = file.parent;
          if (!await parent.exists()) {
            await parent.create(recursive: true);
          }
          final existed = await file.exists();
          await file.writeAsString(newContent);
          return '${existed ? "Updated" : "Created"} $filePath.\n'
              'Summary: $summary\n'
              'Lines: ${newContent.split("\n").length}';
        } catch (e) {
          return 'Error writing file: $e';
        }
      },
    ),
    NexusTool(
      name: 'create_branch',
      description:
          'Create a new git branch and switch to it. Use this when the '
          'user wants to start working on a new feature or fix.',
      parameters: {
        'type': 'object',
        'properties': {
          'branch_name': {
            'type': 'string',
            'description': 'Name for the new branch (e.g. fix/login-bug).',
          },
        },
        'required': ['branch_name'],
      },
      execute: (args) async {
        final name = args['branch_name'] as String;
        final r = await git.createBranch(name);
        if (r.ok) return 'Created and switched to branch: $name';
        return 'Failed to create branch: ${r.stderr}';
      },
    ),
    if (db != null) ...[
      NexusTool(
        name: 'create_issue',
        description:
            'Create a GitHub Issue in the repository. Use this when the '
            'user asks to create an issue or report a bug/feature request. '
            'Requires a GitHub token saved in settings.',
        parameters: {
          'type': 'object',
          'properties': {
            'title': {
              'type': 'string',
              'description': 'Issue title.',
            },
            'body': {
              'type': 'string',
              'description': 'Issue body (Markdown).',
            },
          },
          'required': ['title', 'body'],
        },
        execute: (args) async {
          final title = args['title'] as String;
          final body = args['body'] as String;

          // Read GitHub token from settings
          String token = '';
          try {
            final rows = await db.select(db.settings).get();
            for (final r in rows) {
              if (r.key == 'github_token') {
                token = r.value;
                break;
              }
            }
          } catch (_) {}

          if (token.isEmpty) {
            return 'Error: No GitHub token found. '
                'Please add a GitHub token in Settings first.';
          }

          // Get remote URL
          final git = GitService(repoPath);
          final remote = await git.remoteUrl();
          if (remote == null || remote.isEmpty) {
            return 'Error: No remote origin found. '
                'This repository has no GitHub remote.';
          }

          // Parse owner/repo from remote URL
          // Supports: https://github.com/owner/repo.git or git@github.com:owner/repo.git
          String ownerRepo = remote;
          if (ownerRepo.endsWith('.git')) {
            ownerRepo = ownerRepo.substring(0, ownerRepo.length - 4);
          }
          // Extract owner/repo
          final uri = Uri.tryParse(ownerRepo);
          String? owner;
          String? repo;
          if (uri != null && uri.pathSegments.length >= 2) {
            owner = uri.pathSegments[uri.pathSegments.length - 2];
            repo = uri.pathSegments[uri.pathSegments.length - 1];
          } else {
            // SSH format: git@github.com:owner/repo
            final match = RegExp(r'[:/]([^/]+)/([^/]+)$')
                .firstMatch(ownerRepo);
            if (match != null) {
              owner = match.group(1);
              repo = match.group(2);
            }
          }

          if (owner == null || repo == null) {
            return 'Error: Could not parse owner/repo from remote: $remote';
          }

          // Call GitHub API
          try {
            final uri = Uri.parse(
                'https://api.github.com/repos/$owner/$repo/issues');
            final r = await http.post(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/vnd.github+json',
                'X-GitHub-Api-Version': '2022-11-28',
              },
              body: jsonEncode({'title': title, 'body': body}),
            );
            if (r.statusCode >= 200 && r.statusCode < 300) {
              final data = jsonDecode(r.body) as Map<String, dynamic>;
              final url = data['html_url'] as String? ?? '';
              final number = data['number'] as int? ?? 0;
              return 'Issue #$number created successfully.\nURL: $url';
            } else {
              return 'GitHub API error ${r.statusCode}: ${r.body}';
            }
          } catch (e) {
            return 'Error creating issue: $e';
          }
        },
      ),
    ],
  ];
}