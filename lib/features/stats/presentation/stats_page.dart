import 'package:flutter/material.dart';

import '../data/stats_service.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({required this.repoPath, super.key});
  final String repoPath;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StatsData? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    StatsService(widget.repoPath).compute().then((d) {
      if (mounted) setState(() => _data = d);
    }).catchError((Object e) {
      if (mounted) setState(() => _error = '$e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إحصائياتي')),
      body: _error != null
          ? Center(child: Text(_error!))
          : _data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _card('commits', '${_data!.totalCommits}'),
                        _card('هذا الأسبوع', '${_data!.last7}'),
                        _card('آخر 30ي', '${_data!.last30}'),
                        _card('streak', '${_data!.streak} ي'),
                        _card('ساعة الذروة', '${_data!.mostActiveHour}:00'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('النشاط الأسبوعي',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            for (var i = 0; i < 7; i++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  child: Column(
                                    children: [
                                      Text('${_data!.weekly[i]}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 80 *
                                            (_data!.weekly[i] /
                                                _data!.weekly.fold<int>(
                                                    1,
                                                    (a, b) =>
                                                        a > b ? a : b)),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ['س', 'أ', 'ن', 'ث', 'ر', 'خ', 'ج']
                                            [i],
                                        style:
                                            const TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('أكثر الملفات تعديلاً',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          for (final f in _data!.topFiles)
                            ListTile(
                              dense: true,
                              leading: const Icon(
                                  Icons.description_outlined,
                                  size: 18),
                              title: Text(
                                f.key,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                              ),
                              trailing: Text('${f.value}×'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _card(String label, String value) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}