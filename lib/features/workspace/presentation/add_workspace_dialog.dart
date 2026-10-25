import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddWorkspaceDialog extends StatefulWidget {
  const AddWorkspaceDialog({required this.create, super.key});
  final bool create;

  @override
  State<AddWorkspaceDialog> createState() => _AddWorkspaceDialogState();
}

class _AddWorkspaceDialogState extends State<AddWorkspaceDialog> {
  final _nameCtrl = TextEditingController();
  String? _parent;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickParent() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) setState(() => _parent = path);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (!widget.create) {
      return AlertDialog(
        title: Text(l.openExisting),
        content: const Text(
          'اختر مجلداً يحتوي على .git — أو استخدم "إنشاء" لمستودع جديد.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final path = await FilePicker.platform.getDirectoryPath();
              if (path != null && context.mounted) {
                Navigator.pop(context, path);
              }
            },
            child: Text(l.open),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l.createNew),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l.repoName),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  _parent ?? '—',
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: _pickParent,
                icon: const Icon(Icons.folder_open),
                label: Text(l.open),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty || _parent == null) return;
            Navigator.pop(context, '$_parent/$name');
          },
          child: Text(l.create),
        ),
      ],
    );
  }
}
