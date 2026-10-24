import 'dart:io';

sealed class FileNode {
  const FileNode(this.path, this.name);
  final String path;
  final String name;
}

class FolderNode extends FileNode {
  const FolderNode(super.path, super.name, this.children);
  final List<FileNode> children;
}

class FileLeaf extends FileNode {
  const FileLeaf(super.path, super.name, this.file);
  final File file;
}

Future<FolderNode> buildFileTree(String rootPath) async {
  const ignored = {'.git', 'node_modules', 'build', '.dart_tool', '.idea', '.gradle', 'Pods'};
  final root = Directory(rootPath);

  Future<FolderNode> walk(Directory dir) async {
    final entries = await dir.list(followLinks: false).toList();
    final folders = <FolderNode>[];
    final files = <FileLeaf>[];
    for (final e in entries) {
      final name = e.path.split(RegExp(r'[/\\]')).last;
      if (ignored.contains(name)) continue;
      if (e is Directory) {
        folders.add(await walk(e));
      } else if (e is File) {
        files.add(FileLeaf(e.path, name, e));
      }
    }
    folders.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    files.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final seg = dir.path.split(RegExp(r'[/\\]')).where((e) => e.isNotEmpty).last;
    return FolderNode(dir.path, seg, [...folders, ...files]);
  }

  return walk(root);
}