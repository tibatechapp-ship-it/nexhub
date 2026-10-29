import 'dart:io';
import 'package:flutter/material.dart';

import '../domain/file_node.dart';

class FileTreeWidget extends StatelessWidget {
  const FileTreeWidget({
    required this.root,
    required this.onFileSelected,
    this.selectedPath,
    super.key,
  });

  final FolderNode root;
  final ValueChanged<File> onFileSelected;
  final String? selectedPath;

  @override
  Widget build(BuildContext context) {
    final children = root.children;
    if (children.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('—')));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final n in children)
          _NodeWidget(
            node: n,
            depth: 0,
            onFileSelected: onFileSelected,
            selectedPath: selectedPath,
          ),
      ],
    );
  }
}

class _NodeWidget extends StatelessWidget {
  const _NodeWidget({
    required this.node,
    required this.depth,
    required this.onFileSelected,
    this.selectedPath,
  });

  final FileNode node;
  final int depth;
  final ValueChanged<File> onFileSelected;
  final String? selectedPath;

  @override
  Widget build(BuildContext context) {
    final pad = EdgeInsets.only(right: 8.0 + depth * 14, left: 8);

    if (node is FolderNode) {
      final folder = node as FolderNode;
      if (folder.children.isEmpty) {
        return Padding(
          padding: pad,
          child: ListTile(
            leading: const Icon(Icons.folder_outlined, size: 20),
            title: Text(folder.name),
            dense: true,
          ),
        );
      }
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: pad,
          leading: const Icon(Icons.folder_outlined, size: 20),
          title: Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          childrenPadding: EdgeInsets.zero,
          children: [
            for (final c in folder.children)
              _NodeWidget(
                node: c,
                depth: depth + 1,
                onFileSelected: onFileSelected,
                selectedPath: selectedPath,
              ),
          ],
        ),
      );
    }

    final file = (node as FileLeaf).file;
    final selected = selectedPath == file.path;
    return Padding(
      padding: pad,
      child: ListTile(
        dense: true,
        selected: selected,
        leading: const Icon(Icons.description_outlined, size: 20),
        title: Text(node.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () => onFileSelected(file),
      ),
    );
  }
}