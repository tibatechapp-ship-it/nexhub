import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git/application/git_providers.dart';
import '../../git/data/git_service.dart';

class StatusSheet extends ConsumerStatefulWidget {
  const StatusSheet({required this.repoPath, super.key});
  final String repoPath;

  static Future<void> show(BuildContext context, String repoPath) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatusSheet(repoPath: repoPath),
    );
  }

  @override
  ConsumerState<StatusSheet> createState() => _StatusSheetState();
}

class _StatusSheetState extends ConsumerState<StatusSheet> {
  final _msgCtrl = TextEditingController();
  final _selected = <String>{};
  bool _busy = false;

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _commit() async {
    if (_selected.isEmpty || _msgCtrl.text.trim().isEmpty) return;
    setState(() => _busy = true);
    final git = ref.read(gitServiceProvider(widget.repoPath));
    final stageResult = await git.stage(_selected.toList());
    if (!stageResult.ok) {
      _err(stageResult.stderr);
      return;
    }
    final commitResult = await git.commit(_msgCtrl.text.trim());
    setState(() => _busy = false);
    if (!mounted) return;
    if (commitResult.ok) {
      ref.invalidate(statusProvider(widget.repoPath));
      ref.invalidate(commitsProvider(widget.repoPath));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء commit')),
      );
    } else {
      _err(commitResult.stderr);
    }
  }

  void _err(String msg) {
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusProvider(widget.repoPath));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, scroll) {
        return Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.change_circle_outlined),
                  const SizedBox(width: 8),
                  Text('التغييرات',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(statusProvider(widget.repoPath)),
                    child: const Text('تحديث'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: status.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Center(child: Text('لا توجد تغييرات'));
                  }
                  return ListView(
                    controller: scroll,
                    children: [for (final e in entries) _tile(e)],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                12 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _msgCtrl,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'رسالة الـ commit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_selected.length} ملف محدد',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _busy ? null : _commit,
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: const Text('Commit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(StatusEntry e) {
    final checked = _selected.contains(e.path);
    return CheckboxListTile(
      value: checked,
      onChanged: (v) => setState(() {
        if (v == true) {
          _selected.add(e.path);
        } else {
          _selected.remove(e.path);
        }
      }),
      title: Text(
        e.path,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.start,
      ),
      subtitle: Text(e.statusLabel),
      secondary: Icon(
        e.staged ? Icons.check_circle : Icons.circle_outlined,
        color: e.staged ? Colors.green : Theme.of(context).colorScheme.outline,
      ),
    );
  }
}