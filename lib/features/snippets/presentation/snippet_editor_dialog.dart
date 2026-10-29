import 'package:flutter/material.dart';

import '../../../core/ui/feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';
import '../data/snippets_repository.dart';

class SnippetEditorDialog extends ConsumerStatefulWidget {
  const SnippetEditorDialog({this.existing, super.key});
  final Snippet? existing;

  static Future<void> show(BuildContext context, {Snippet? existing}) {
    return showDialog<void>(
      context: context,
      builder: (_) => SnippetEditorDialog(existing: existing),
    );
  }

  @override
  ConsumerState<SnippetEditorDialog> createState() =>
      _SnippetEditorDialogState();
}

class _SnippetEditorDialogState extends ConsumerState<SnippetEditorDialog> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _body = TextEditingController(text: widget.existing?.body ?? '');
  late final _lang = TextEditingController(
      text: widget.existing?.language ?? 'plaintext');
  late final _tags = TextEditingController(text: widget.existing?.tags ?? '');

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _lang.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) return;
    final repo = ref.read(snippetsRepositoryProvider);
    if (widget.existing == null) {
      await repo.add(
        title: _title.text.trim(),
        body: _body.text,
        language: _lang.text.trim(),
        tags: _tags.text.trim(),
      );
    } else {
      await repo.update(
        widget.existing!.id,
        title: _title.text.trim(),
        body: _body.text,
        language: _lang.text.trim(),
        tags: _tags.text.trim(),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.existing == null) return;
    await ref.read(snippetsRepositoryProvider).remove(widget.existing!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    widget.existing == null ? 'مقتطف جديد' : 'تحرير',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (widget.existing != null)
                    IconButton(
                      tooltip: 'حذف المقتطف',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _delete,
                    ),
                  IconButton(
                    tooltip: 'إغلاق',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lang,
                      decoration: const InputDecoration(
                        labelText: 'اللغة (dart, python, ...)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _tags,
                      decoration: const InputDecoration(
                        labelText: 'وسوم (مفصولة بفاصلة)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TextField(
                  controller: _body,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'الكود',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('حفظ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}