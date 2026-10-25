import 'dart:io';

class GitResult {
  const GitResult(this.exitCode, this.stdout, this.stderr);
  final int exitCode;
  final String stdout;
  final String stderr;
  bool get ok => exitCode == 0;
}

class GitService {
  GitService(this.repoPath);
  final String repoPath;

  Future<GitResult> _run(List<String> args) async {
    final r = await Process.run(
      'git',
      args,
      workingDirectory: repoPath,
      stdoutEncoding: systemEncoding,
      stderrEncoding: systemEncoding,
    );
    return GitResult(
      r.exitCode,
      (r.stdout as String).trimRight(),
      (r.stderr as String).trimRight(),
    );
  }

  Future<bool> isRepo() async {
    final r = await _run(['rev-parse', '--is-inside-work-tree']);
    return r.ok && r.stdout == 'true';
  }

  Future<String?> currentBranch() async {
    final r = await _run(['rev-parse', '--abbrev-ref', 'HEAD']);
    if (!r.ok) return null;
    return r.stdout.trim();
  }

  Future<List<CommitInfo>> log({int limit = 60}) async {
    final r = await _run([
      'log',
      '--no-color',
      '--pretty=format:%H%x1f%an%x1f%ae%x1f%aI%x1f%s',
      '-n',
      '$limit',
    ]);
    if (!r.ok || r.stdout.isEmpty) return const [];
    return r.stdout.split('\n').where((l) => l.isNotEmpty).map((line) {
      final p = line.split('\x1f');
      return CommitInfo(
        hash: p[0],
        shortHash: p[0].substring(0, 7),
        author: p[1],
        email: p[2],
        date: DateTime.tryParse(p[3]) ?? DateTime.now(),
        subject: p.length > 4 ? p[4] : '',
      );
    }).toList();
  }

  Future<String> commitDiff(String hash) async {
    final r = await _run(['show', '--no-color', '--format=medium', hash]);
    return r.ok ? r.stdout : r.stderr;
  }

  Future<List<BranchInfo>> branches() async {
    final r = await _run([
      'branch',
      '--all',
      '--format=%(refname:short)%1f%(HEAD)',
    ]);
    if (!r.ok) return const [];
    return r.stdout
        .split('\n')
        .where((l) => l.isNotEmpty)
        .map((line) {
          final p = line.split('\x1f');
          final name = p[0];
          final isHead = p.length > 1 && p[1] == '*';
          return BranchInfo(
            name: name,
            isCurrent: isHead,
            isRemote: name.startsWith('origin/') || name.startsWith('remotes/'),
          );
        })
        .toList();
  }

  Future<GitResult> checkout(String branch) => _run(['checkout', branch]);

  Future<GitResult> createBranch(String name) =>
      _run(['checkout', '-b', name]);

  Future<List<StatusEntry>> status() async {
    final r = await _run(['status', '--porcelain=v1', '--untracked-files=all']);
    if (!r.ok) return const [];
    return r.stdout.split('\n').where((l) => l.length >= 3).map((line) {
      final code = line.substring(0, 2);
      final path = line.substring(3).trim();
      return StatusEntry.fromCode(code, path);
    }).toList();
  }

  Future<GitResult> stage(List<String> paths) =>
      _run(['add', '--', ...paths]);

  Future<GitResult> unstage(List<String> paths) =>
      _run(['reset', 'HEAD', '--', ...paths]);

  Future<GitResult> commit(String message) =>
      _run(['commit', '-m', message]);

  Future<GitResult> amend(String message) =>
      _run(['commit', '--amend', '-m', message]);

  Future<String> diffBranches(String base, String head) async {
    final r = await _run(['diff', '--no-color', '$base..$head']);
    return r.ok ? r.stdout : r.stderr;
  }

  Future<GitResult> mergeBranch(String branch) =>
      _run(['merge', '--no-ff', '--no-edit', branch]);

  Future<GitResult> mergeAbort() => _run(['merge', '--abort']);

  Future<GitResult> mergeContinue() => _run(['commit', '--no-edit']);

  Future<List<String>> conflictedFiles() async {
    final r = await _run(['diff', '--name-only', '--diff-filter=U']);
    if (!r.ok || r.stdout.isEmpty) return const [];
    return r.stdout.split('\n').where((l) => l.isNotEmpty).toList();
  }

  Future<void> stageAll() async => _run(['add', '-A']);
}

class CommitInfo {
  const CommitInfo({
    required this.hash,
    required this.shortHash,
    required this.author,
    required this.email,
    required this.date,
    required this.subject,
  });
  final String hash;
  final String shortHash;
  final String author;
  final String email;
  final DateTime date;
  final String subject;
}

class BranchInfo {
  const BranchInfo({
    required this.name,
    required this.isCurrent,
    required this.isRemote,
  });
  final String name;
  final bool isCurrent;
  final bool isRemote;
}

class StatusEntry {
  const StatusEntry({
    required this.path,
    required this.staged,
    required this.working,
    required this.statusLabel,
  });

  final String path;
  final bool staged;
  final bool working;
  final String statusLabel;

  factory StatusEntry.fromCode(String code, String path) {
    final x = code[0];
    final y = code[1];
    final staged = x != ' ' && x != '?';
    final working = y != ' ' && y != '?';
    final untracked = x == '?' && y == '?';

    String label;
    if (untracked) {
      label = 'غير متتبع';
    } else if (x == 'A') {
      label = 'مضاف';
    } else if (x == 'M' || y == 'M') {
      label = 'معدّل';
    } else if (x == 'D' || y == 'D') {
      label = 'محذوف';
    } else if (x == 'R') {
      label = 'معاد تسميته';
    } else {
      label = 'تغيير';
    }

    return StatusEntry(
      path: path,
      staged: staged,
      working: working,
      statusLabel: label,
    );
  }
}