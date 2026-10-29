import 'dart:io';

import 'package:flutter/material.dart';

class SyncSheet extends StatefulWidget {
  const SyncSheet({required this.repoPath, super.key});
  final String repoPath;

  static Future<void> show(BuildContext context, String repoPath) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SyncSheet(repoPath: repoPath),
      );

  @override
  State<SyncSheet> createState() => _SyncSheetState();
}

class _SyncSheetState extends State<SyncSheet> {
  String? _remote;
  String? _status;
  bool _busy = false;

  Future<String> _git(List<String> args) async {
    final r = await Process.run('git', args,
        workingDirectory: widget.repoPath,
        stdoutEncoding: systemEncoding,
        stderrEncoding: systemEncoding);
    return r.exitCode == 0 ? (r.stdout as String).trim() : (r.stderr as String).trim();
  }

  Future<void> _init() async {
    final r = await _git(['config', '--get', 'remote.origin.url']);
    if (mounted) setState(() => _remote = r.isEmpty ? null : r);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _run(List<String> args, String label) async {
    setState(() {
      _busy = true;
      _status = null;
    });
    final r = await _git(args);
    if (mounted) {
      setState(() {
        _busy = false;
        _status = r;
      });
      await _init();
    }
  }

  Future<void> _setupRemote() async {
    final ctrl = TextEditingController(text: _remote ?? '');
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('عنوان remote'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'git@github.com:user/repo.git',
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.ltr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (url == null || url.isEmpty) return;
    await _git(['remote', 'remove', 'origin']);
    final r = await _git(['remote', 'add', 'origin', url]);
    if (mounted) {
      setState(() => _remote = url);
      _status = r;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.sync),
              const SizedBox(width: 8),
              Text('المزامنة', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                tooltip: 'إغلاق',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          if (_remote == null)
            Column(
              children: [
                const Text('لا يوجد remote مضبوط'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _setupRemote,
                  icon: const Icon(Icons.link),
                  label: const Text('إضافة remote'),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(_remote!,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _run(['fetch', '--all', '--prune'], 'fetch'),
                      icon: const Icon(Icons.cloud_download_outlined),
                      label: const Text('جلب'),
                    ),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _run(['pull', '--ff-only'], 'pull'),
                      icon: const Icon(Icons.south),
                      label: const Text('سحب'),
                    ),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _run(['push', 'origin', 'HEAD'], 'push'),
                      icon: const Icon(Icons.north),
                      label: const Text('دفع'),
                    ),
                    TextButton.icon(
                      onPressed: _setupRemote,
                      icon: const Icon(Icons.edit),
                      label: const Text('تعديل'),
                    ),
                  ],
                ),
              ],
            ),
          if (_busy) const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
          if (_status != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_status!, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
