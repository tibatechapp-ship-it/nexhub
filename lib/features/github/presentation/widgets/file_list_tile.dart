import 'package:flutter/material.dart';
import '../../data/github_models.dart';

class FileListTile extends StatelessWidget {
  final GithubContent item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FileListTile({super.key, required this.item, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.isDirectory ? Icons.folder : Icons.insert_drive_file),
      title: Text(item.name),
      subtitle: Text(item.isDirectory ? 'مجلد' : '${item.size} bytes'),
      trailing: item.isDirectory ? null : IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
      onTap: onTap,
    );
  }
}
