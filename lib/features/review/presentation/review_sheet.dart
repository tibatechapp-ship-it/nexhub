import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git/application/git_providers.dart';
import '../../history/presentation/history_page.dart' show DiffText;

class ReviewSheet extends ConsumerStatefulWidget {
  const ReviewSheet({required this.repoPath, super.key});
  final String repoPath;

  static Future<void> show(BuildContext context, String repoPath) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewSheet(repoPath: repoPath),
    );
  }

  @override
  ConsumerState<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<ReviewSheet> {
  String? _base;
  String? _head;
  String? _diff;
  bool _loading = false;

  Future<void> _run() async {
    if (_base == null || _head == null) return;
    setState(() {
      _loading = true;
      _diff = null;
    });
    final d = await ref
        .read(gitServiceProvider(widget.repoPath))
        .diffBranches(_base!, _head!);
    if (mounted) {
      setState(() {
        _diff = d;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(branchesProvider(widget.repoPath));

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
                  const Icon(Icons.compare_arrows),
                  const SizedBox(width: 8),
                  Text('مراجعة محلية',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    tooltip: 'إغلاق',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            branches.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('$e'),
              ),
              data: (list) {
                final local = list.where((b) => !b.isRemote).toList();
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _base,
                          decoration: const InputDecoration(
                            labelText: 'الأساس',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final b in local)
                              DropdownMenuItem(
                                value: b.name,
                                child: Text(b.name,
                                    textDirection: TextDirection.ltr),
                              ),
                          ],
                          onChanged: (v) => setState(() => _base = v),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _head,
                          decoration: const InputDecoration(
                            labelText: 'المقارن',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final b in local)
                              DropdownMenuItem(
                                value: b.name,
                                child: Text(b.name,
                                    textDirection: TextDirection.ltr),
                              ),
                          ],
                          onChanged: (v) => setState(() => _head = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _base != null &&
                                _head != null &&
                                _base != _head
                            ? _run
                            : null,
                        child: const Text('قارن'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _diff == null
                      ? const Center(child: Text('اختر فرعين للمقارنة'))
                      : _diff!.trim().isEmpty
                          ? const Center(child: Text('لا فروق'))
                          : SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: DiffText(diff: _diff!),
                                ),
                              ),
                            ),
            ),
          ],
        );
      },
    );
  }
}