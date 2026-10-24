import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/l10n/app_localizations.dart';

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
        switch (d.kind) {
          case _Kind.binary:
            return Center(child: Text(l.binaryFile));
          case _Kind.tooLarge:
            return Center(child: Text(l.fileTooLarge));
          case _Kind.text:
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
      },
    );
  }

  Future<FileData> _load(File f) async {
    final stat = await f.stat();
    if (stat.size > 1024 * 1024) {
      return const FileData(kind: _Kind.tooLarge, ext: '');
    }
    final bytes = await f.readAsBytes();
    if (bytes.take(8000).contains(0)) {
      return const FileData(kind: _Kind.binary, ext: '');
    }
    try {
      final text = utf8.decode(bytes);
      final name = f.path.split(RegExp(r'[/\\]')).last.toLowerCase();
      final i = name.lastIndexOf('.');
      final ext = i < 0 ? '' : name.substring(i);
      return FileData(kind: _Kind.text, ext: ext, text: text);
    } catch (_) {
      return const FileData(kind: _Kind.binary, ext: '');
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

enum _Kind { text, binary, tooLarge }

class FileData {
  const FileData({required this.kind, required this.ext, this.text});
  final _Kind kind;
  final String ext;
  final String? text;
}