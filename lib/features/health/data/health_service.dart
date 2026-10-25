import 'dart:io';

class FileInfo {
  const FileInfo({required this.path, required this.size});
  final String path;
  final int size;
}

class HealthReport {
  const HealthReport({
    required this.gitSize,
    required this.trackedSize,
    required this.totalFiles,
    required this.uncommitted,
    required this.todoCount,
    required this.largeFiles,
    required this.staleBranches,
    required this.suggestions,
  });

  final int gitSize;
  final int trackedSize;
  final int totalFiles;
  final int uncommitted;
  final int todoCount;
  final List<FileInfo> largeFiles;
  final List<String> staleBranches;
  final List<String> suggestions;
}

class HealthService {
  HealthService(this.repoPath);
  final String repoPath;

  Future<HealthReport> compute() async {
    final gitSize = await _dirSize(Directory('$repoPath/.git'));

    final lsTree = await _git(['ls-tree', '-r', '-l', 'HEAD']);
    final files = <FileInfo>[];
    int trackedSize = 0;
    for (final line in lsTree.split('\n')) {
      final tab = line.indexOf('\t');
      if (tab < 0) continue;
      final before = line.substring(0, tab);
      final path = line.substring(tab + 1);
      final parts = before.split(RegExp(r'\s+'));
      if (parts.length < 4) continue;
      final size = int.tryParse(parts[3]) ?? 0;
      trackedSize += size;
      files.add(FileInfo(path: path, size: size));
    }
    files.sort((a, b) => b.size.compareTo(a.size));

    final status = await _git(['status', '--porcelain=v1']);
    final uncommitted = status
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .length;

    final grep = await _git([
      'grep', '-n', '-I', '-E', 'TODO|FIXME|XXX',
      '--',
      ':(exclude)*.md',
      ':(exclude)*.lock',
    ]);
    final todoCount =
        grep.split('\n').where((l) => l.trim().isNotEmpty).length;

    final stale = <String>[];
    final refs = await _git([
      'for-each-ref',
      '--format=%(refname:short)%1f%(committerdate:unix)',
      'refs/heads/',
    ]);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    for (final line in refs.split('\n')) {
      if (line.trim().isEmpty) continue;
      final parts = line.split('\x1f');
      if (parts.length < 2) continue;
      final ts = int.tryParse(parts[1]) ?? 0;
      final days = ((now - ts) / 86400).floor();
      if (days > 60) stale.add('${parts[0]} (${days}ي)');
    }

    final suggestions = <String>[];
    if (gitSize > 100 * 1024 * 1024) {
      suggestions.add('.git كبير (>100MB) — جرّب git gc --aggressive');
    }
    if (files.any((f) => f.size > 5 * 1024 * 1024)) {
      suggestions.add('ملفات ضخمة (>5MB) — فكّر بـ Git LFS');
    }
    if (uncommitted > 20) {
      suggestions.add('$uncommitted تغيير غير محفوظ — راجع قبل الفقدان');
    }
    if (stale.isNotEmpty) {
      suggestions.add('${stale.length} فرع ميت (>60 يوم) — احذفه');
    }
    if (todoCount > 50) {
      suggestions.add('$todoCount TODO — راجع backlog');
    }
    if (suggestions.isEmpty) {
      suggestions.add('المستودع في حالة جيدة ✓');
    }

    return HealthReport(
      gitSize: gitSize,
      trackedSize: trackedSize,
      totalFiles: files.length,
      uncommitted: uncommitted,
      todoCount: todoCount,
      largeFiles: files.take(10).toList(),
      staleBranches: stale,
      suggestions: suggestions,
    );
  }

  Future<String> _git(List<String> args) async {
    final r = await Process.run(
      'git',
      args,
      workingDirectory: repoPath,
      stdoutEncoding: const SystemEncoding(),
      stderrEncoding: const SystemEncoding(),
    );
    return r.exitCode == 0 ? (r.stdout as String).trimRight() : '';
  }

  Future<int> _dirSize(Directory dir) async {
    if (!await dir.exists()) return 0;
    int total = 0;
    try {
      await for (final e in dir.list(recursive: true, followLinks: false)) {
        if (e is File) {
          try {
            total += await e.length();
          } catch (_) {}
        }
      }
    } catch (_) {}
    return total;
  }
}