import 'dart:io';

class StatsData {
  const StatsData({
    required this.totalCommits,
    required this.last7,
    required this.last30,
    required this.streak,
    required this.topFiles,
    required this.mostActiveHour,
    required this.weekly,
  });

  final int totalCommits;
  final int last7;
  final int last30;
  final int streak;
  final List<MapEntry<String, int>> topFiles;
  final int mostActiveHour;
  final List<int> weekly;
}

class StatsService {
  StatsService(this.repoPath);
  final String repoPath;

  Future<StatsData> compute() async {
    final countRes = await _git(['rev-list', '--count', 'HEAD']);
    final total = int.tryParse(countRes) ?? 0;

    final logDates = await _git(['log', '--pretty=format:%aI', '-n', '2000']);
    final dates = logDates
        .split('\n')
        .where((l) => l.isNotEmpty)
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .toList();

    final logFiles =
        await _git(['log', '--pretty=format:', '--name-only', '-n', '500']);
    final fileCounts = <String, int>{};
    for (final line in logFiles.split('\n')) {
      final t = line.trim();
      if (t.isEmpty) continue;
      fileCounts[t] = (fileCounts[t] ?? 0) + 1;
    }
    final topFiles = fileCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final now = DateTime.now();
    final last7 = dates.where((d) => now.difference(d).inDays < 7).length;
    final last30 = dates.where((d) => now.difference(d).inDays < 30).length;

    final days =
        dates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;
    for (var i = 0; i < 366; i++) {
      final day = today.subtract(Duration(days: i));
      if (days.contains(day)) {
        streak++;
      } else if (i == 0) {
        continue;
      } else {
        break;
      }
    }

    final hours = <int, int>{};
    for (final d in dates) {
      hours[d.hour] = (hours[d.hour] ?? 0) + 1;
    }
    final activeHour = hours.isEmpty
        ? 12
        : (hours.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key;

    final weekly = List<int>.filled(7, 0);
    for (final d in dates) {
      final diff = now.difference(d).inDays;
      if (diff < 7 && diff >= 0) weekly[6 - diff]++;
    }

    return StatsData(
      totalCommits: total,
      last7: last7,
      last30: last30,
      streak: streak,
      topFiles: topFiles.take(15).toList(),
      mostActiveHour: activeHour,
      weekly: weekly,
    );
  }

  Future<String> _git(List<String> args) async {
    final r = await Process.run(
      'git',
      args,
      workingDirectory: repoPath,
      stdoutEncoding: systemEncoding,
      stderrEncoding: systemEncoding,
    );
    return r.exitCode == 0 ? (r.stdout as String).trimRight() : '';
  }
}