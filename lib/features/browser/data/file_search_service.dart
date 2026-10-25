

import '../../../core/utils/arabic_normalizer.dart';
import '../domain/file_node.dart';

class SearchHit {
  SearchHit({
    required this.path,
    required this.name,
    required this.isContent,
    this.line,
    this.snippet,
  });

  final String path;
  final String name;
  final bool isContent;
  final int? line;
  final String? snippet;
}

class FileSearchService {
  static const _binaryExt = {
    '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.pdf', '.zip', '.gz',
    '.tar', '.jar', '.apk', '.ipa', '.dll', '.so', '.dylib', '.exe', '.bin',
    '.mp3', '.mp4', '.mov', '.wav', '.ttf', '.otf', '.woff', '.woff2',
    '.sqlite', '.db',
  };

  Future<List<SearchHit>> search({
    required FolderNode root,
    required String query,
    int maxResults = 100,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final hits = <SearchHit>[];
    final files = <FileLeaf>[];
    void walk(FileNode n) {
      if (n is FolderNode) {
        for (final c in n.children) {
          walk(c);
        }
      } else if (n is FileLeaf) {
        files.add(n);
      }
    }
    walk(root);

    for (final f in files) {
      if (arabicContains(f.name, q)) {
        hits.add(SearchHit(path: f.path, name: f.name, isContent: false));
        if (hits.length >= maxResults) return hits;
      }
    }

    for (final f in files) {
      final ext = _ext(f.name);
      if (_binaryExt.contains(ext)) continue;
      try {
        final stat = await f.file.stat();
        if (stat.size > 500 * 1024) continue;
        final text = await f.file.readAsString();
        if (!arabicContains(text, q)) continue;
        final lines = text.split('\n');
        final normQ = normalizeForSearch(q);
        for (var i = 0; i < lines.length; i++) {
          if (normalizeForSearch(lines[i]).contains(normQ)) {
            hits.add(SearchHit(
              path: f.path,
              name: f.name,
              isContent: true,
              line: i + 1,
              snippet: lines[i].trim(),
            ));
            if (hits.length >= maxResults) return hits;
            break;
          }
        }
      } catch (_) {}
    }
    return hits;
  }

  String _ext(String name) {
    final i = name.lastIndexOf('.');
    return i < 0 ? '' : name.substring(i).toLowerCase();
  }
}