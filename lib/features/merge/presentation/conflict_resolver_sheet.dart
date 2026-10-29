import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git/application/git_providers.dart';

import '../../../core/ui/feedback.dart';

enum _Choice { ours, theirs, both }

class ConflictResolverSheet extends ConsumerStatefulWidget {
  const ConflictResolverSheet({
    required this.repoPath,
    required this.files,
    super.key,
  });
  final String repoPath;
  final List<String> files;

  static Future<void> show(
    BuildContext context, {
    required String repoPath,
    required List<String> files,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => ConflictResolverSheet(repoPath: repoPath, files: files),
    );
  }

  @override
  ConsumerState<ConflictResolverSheet> createState() =>
      _ConflictResolverSheetState();
}

class _ConflictResolverSheetState extends ConsumerState<ConflictResolverSheet> {
  int _idx = 0;
  final _controllers = <String, TextEditingController>{};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    for (final f in widget.files) {
      final file = File('${widget.repoPath}/$f');
      if (await file.exists()) {
        _controllers[f] = TextEditingController(text: await file.readAsString());
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _applyAll(_Choice choice) {
    final key = widget.files[_idx];
    final ctrl = _controllers[key];
    if (ctrl == null) return;
    final re = RegExp(
      r'<<<<<<<[^\n]*\n([\s\S]*?)=======\n([\s\S]*?)>>>>>>>[^\n]*\n?',
      multiLine: true,
    );
    ctrl.text = ctrl.text.replaceAllMapped(re, (m) {
      final ours = m[1]!;
      final theirs = m[2]!;
      return switch (choice) {
        _Choice.ours => ours,
        _Choice.theirs => theirs,
        _Choice.both => '$ours$theirs',
      };
    });
    setState(() {});
  }

  Future<void> _saveAndNext() async {
    setState(() => _busy = true);
    final key = widget.files[_idx];
    final ctrl = _controllers[key];
    if (ctrl != null) {
      await File('${widget.repoPath}/$key').writeAsString(ctrl.text);
    }
    if (_idx < widget.files.length - 1) {
      setState(() {
        _idx++;
        _busy = false;
      });
      return;
    }
    final git = ref.read(gitServiceProvider(widget.repoPath));
    await git.stageAll();
    final r = await git.mergeContinue();
    if (!mounted) return;
    setState(() => _busy = false);
    if (r.ok) {
      ref.invalidate(statusProvider(widget.repoPath));
      ref.invalidate(commitsProvider(widget.repoPath));
      ref.invalidate(branchesProvider(widget.repoPath));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الدمج')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(r.stderr)),
      );
    }
  }

  Future<void> _abort() async {
    final git = ref.read(gitServiceProvider(widget.repoPath));
    await git.mergeAbort();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_controllers.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final f = widget.files[_idx];
    final ctrl = _controllers[f]!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      maxChildSize: 0.98,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تعارض ${_idx + 1} من ${widget.files.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // UX audit: abort discards in-progress resolution — confirm first.
                      final ok = await confirmAction(
                        context,
                        title: 'إحباط الدمج؟',
                        message: 'سيتم التراجع عن الدمج وإلغاء كل قراراتك الحالية.',
                        confirmLabel: 'إحباط',
                      );
                      if (ok) _abort();
                    },
                    child: const Text('إحباط الدمج'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                f,
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _applyAll(_Choice.ours),
                  icon: const Icon(Icons.person, size: 16),
                  label: const Text('خذ نسختي (كل التعارضات)'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _applyAll(_Choice.theirs),
                  icon: const Icon(Icons.people, size: 16),
                  label: const Text('خذ نسختهم'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _applyAll(_Choice.both),
                  icon: const Icon(Icons.merge, size: 16),
                  label: const Text('خذ الاثنين'),
                ),
              ],
            ),
            const Divider(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: ctrl,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'حرّر النص بحرية أو استخدم الأزرار أعلاه',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _busy ? null : _saveAndNext,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_idx == widget.files.length - 1
                            ? Icons.check
                            : Icons.arrow_back),
                    label: Text(_idx == widget.files.length - 1
                        ? 'حفظ وإكمال الدمج'
                        : 'حفظ والتالي'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}