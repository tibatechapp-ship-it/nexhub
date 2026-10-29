import 'package:flutter/material.dart';

import '../data/health_service.dart';

class HealthSheet extends StatefulWidget {
  const HealthSheet({required this.repoPath, super.key});
  final String repoPath;

  static Future<void> show(BuildContext context, String repoPath) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => HealthSheet(repoPath: repoPath),
      );

  @override
  State<HealthSheet> createState() => _HealthSheetState();
}

class _HealthSheetState extends State<HealthSheet> {
  HealthReport? _report;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await HealthService(widget.repoPath).compute();
      if (mounted) setState(() => _report = r);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  String _size(int b) {
    if (b < 1024) return '$b ب';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} ك';
    if (b < 1024 * 1024 * 1024) {
      return '${(b / 1024 / 1024).toStringAsFixed(1)} م';
    }
    return '${(b / 1024 / 1024 / 1024).toStringAsFixed(2)} غ';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.97,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.health_and_safety_outlined),
                  const SizedBox(width: 8),
                  Text('فحص صحي',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    tooltip: 'إعادة الفحص',
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() => _report = null);
                      _load();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _error != null
                  ? Center(child: Text(_error!))
                  : _report == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          controller: scroll,
                          padding: const EdgeInsets.all(16),
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _stat('الحجم الكلي',
                                    _size(_report!.trackedSize)),
                                _stat('.git', _size(_report!.gitSize)),
                                _stat('ملفات', '${_report!.totalFiles}'),
                                _stat('غير محفوظة', '${_report!.uncommitted}'),
                                _stat('TODO', '${_report!.todoCount}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_report!.suggestions.isNotEmpty) ...[
                              Text('توصيات',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Card(
                                color: scheme.secondaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (final s in _report!.suggestions)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.tips_and_updates,
                                                  size: 16),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(s)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (_report!.largeFiles.isNotEmpty) ...[
                              Text('أكبر الملفات',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Card(
                                child: Column(
                                  children: [
                                    for (final f in _report!.largeFiles)
                                      ListTile(
                                        dense: true,
                                        title: Text(f.path,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textDirection:
                                                TextDirection.ltr),
                                        trailing: Text(_size(f.size)),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                            if (_report!.staleBranches.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text('فروع ميتة',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Card(
                                child: Column(
                                  children: [
                                    for (final b in _report!.staleBranches)
                                      ListTile(
                                        dense: true,
                                        leading: const Icon(
                                            Icons.account_tree_outlined,
                                            size: 18),
                                        title: Text(b,
                                            textDirection:
                                                TextDirection.ltr),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _stat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}