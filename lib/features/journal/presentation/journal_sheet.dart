import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/journal_repository.dart';

class JournalSheet extends ConsumerStatefulWidget {
  const JournalSheet({
    required this.repoPath,
    this.commitHash,
    this.commitSubject,
    super.key,
  });
  final String repoPath;
  final String? commitHash;
  final String? commitSubject;

  static Future<void> show(
    BuildContext context, {
    required String repoPath,
    String? commitHash,
    String? commitSubject,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => JournalSheet(
        repoPath: repoPath,
        commitHash: commitHash,
        commitSubject: commitSubject,
      ),
    );
  }

  @override
  ConsumerState<JournalSheet> createState() => _JournalSheetState();
}

class _JournalSheetState extends ConsumerState<JournalSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (_title.text.trim().isEmpty) return;
    await ref.read(journalRepositoryProvider).add(
          repoPath: widget.repoPath,
          commitHash: widget.commitHash,
          title: _title.text.trim(),
          body: _body.text.trim(),
        );
    _title.clear();
    _body.clear();
  }

  @override
  Widget build(BuildContext context) {
    final stream = widget.commitHash == null
        ? ref.watch(journalRepositoryProvider).watchForRepo(widget.repoPath)
        : ref
            .watch(journalRepositoryProvider)
            .watchForCommit(widget.repoPath, widget.commitHash!);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.commitHash == null
                          ? 'المذكرات'
                          : 'مذكرات ${widget.commitHash!.substring(0, 7)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (widget.commitSubject != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    widget.commitSubject!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'عنوان الملاحظة',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _body,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'لماذا فعلت هذا؟',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FilledButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder(
                stream: stream,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final entries = snap.data!;
                  if (entries.isEmpty) {
                    return const Center(child: Text('لا ملاحظات بعد'));
                  }
                  return ListView.separated(
                    controller: scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final e = entries[i];
                      return Card(
                        child: ListTile(
                          title: Text(e.title),
                          subtitle: e.body.isEmpty ? null : Text(e.body),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(journalRepositoryProvider)
                                .remove(e.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}