import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ai/presentation/explain_sheet.dart';
import '../../editor/presentation/editor_page.dart';

class FileViewerWidget extends StatelessWidget {
  const FileViewerWidget({required this.file, super.key});
  final File? file;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = file;
    if (f == null) {
      return Center(
        child: Text(
          l.browseFiles,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return FutureBuilder<FileData>(
      future: _load(f),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final d = snap.data!;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      f.path.split(RegExp(r'[/\\]')).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: d.kind == FileKind.text
                        ? () => ExplainSheet.show(
                              context,
                              code: d.text!.length > 6000
                                  ? d.text!.substring(0, 6000)
                                  : d.text!,
                              fileName: f.path.split(RegExp(r'[/\\]')).last,
                            )
                        : null,
                    icon: const Icon(Icons.smart_toy_outlined, size: 18),
                    label: const Text('اشرح'),
                  ),
                  TextButton.icon(
                    onPressed: () => EditorPage.open(context, f.path),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تحرير'),
                  ),
                ],
              ),
            ),
            Expanded(child: _content(context, d, l)),
          ],
        );
      },
    );
  }

  Widget _content(BuildContext context, FileData d, AppLocalizations l) {
    switch (d.kind) {
      case FileKind.binary:
        return Center(child: Text(l.binaryFile));
      case FileKind.tooLarge:
        return Center(child: Text(l.fileTooLarge));
      case FileKind.text:
        if (d.ext == '.md' || d.ext == '.markdown') {
          return Markdown(
            data: d.text!,
            selectable: true,
            padding: const EdgeInsets.all(16),
          );
        }
        final dark = Theme.of(context).brightness == Brightness.dark;
        final lang = _langFromExt(d.ext);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              d.text!,
              language: lang,
              theme: dark ? atomOneDarkTheme : atomOneLightTheme,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
        );
    }
  }

  Future<FileData> _load(File f) async {
    final stat = await f.stat();
    if (stat.size > 1024 * 1024) {
      return const FileData(kind: FileKind.tooLarge, ext: '');
    }
    final bytes = await f.readAsBytes();
    if (bytes.take(8000).contains(0)) {
      return const FileData(kind: FileKind.binary, ext: '');
    }
    try {
      final text = utf8.decode(bytes);
      final name = f.path.split(RegExp(r'[/\\]')).last.toLowerCase();
      final i = name.lastIndexOf('.');
      final ext = i < 0 ? '' : name.substring(i);
      return FileData(kind: FileKind.text, ext: ext, text: text);
    } catch (_) {
      return const FileData(kind: FileKind.binary, ext: '');
    }
  }

  String _langFromExt(String ext) {
    const map = {
      '.dart': 'dart',
      '.js': 'javascript',
      '.ts': 'typescript',
      '.jsx': 'javascript',
      '.tsx': 'typescript',
      '.py': 'python',
      '.java': 'java',
      '.kt': 'kotlin',
      '.swift': 'swift',
      '.go': 'go',
      '.rs': 'rust',
      '.rb': 'ruby',
      '.php': 'php',
      '.c': 'c',
      '.cpp': 'cpp',
      '.h': 'c',
      '.hpp': 'cpp',
      '.cs': 'csharp',
      '.html': 'html',
      '.css': 'css',
      '.scss': 'scss',
      '.json': 'json',
      '.yaml': 'yaml',
      '.yml': 'yaml',
      '.xml': 'xml',
      '.sh': 'bash',
      '.sql': 'sql',
    };
    return map[ext] ?? 'plaintext';
  }
}

enum FileKind { text, binary, tooLarge }

class FileData {
  const FileData({required this.kind, required this.ext, this.text});
  final FileKind kind;
  final String ext;
  final String? text;
}