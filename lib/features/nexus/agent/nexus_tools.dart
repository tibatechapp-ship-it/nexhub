import 'dart:io';


import '../../git/data/git_service.dart';

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
        final file = File('$repoPath/$path');
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
        final directory = Directory('$repoPath/$dir');
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
  ];
}