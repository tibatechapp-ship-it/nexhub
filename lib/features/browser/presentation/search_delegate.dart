import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/file_search_service.dart';
import '../domain/file_node.dart';

class FileSearchDelegate extends SearchDelegate<File?> {
  FileSearchDelegate({required this.rootPath});
  final String rootPath;

  final _service = FileSearchService();
  Future<List<SearchHit>>? _future;

  BuildContext? _context;

  @override
  String get searchFieldLabel {
    final ctx = _context;
    if (ctx == null) return 'search';
    return AppLocalizations.of(ctx).searchPlaceholder;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
              _future = null;
            },
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    _context = context;
    final l = AppLocalizations.of(context);
    if (query.trim().isEmpty) {
      return Center(child: Text(l.searchPlaceholder));
    }
    _future ??= _run();
    return FutureBuilder<List<SearchHit>>(
      future: _future,
      builder: (context, snap) {
        if (!snap.hasData) return Center(child: Text(l.searching));
        final hits = snap.data!;
        if (hits.isEmpty) return Center(child: Text(l.noSearchResults));
        return ListView.builder(
          itemCount: hits.length,
          itemBuilder: (_, i) {
            final h = hits[i];
            return ListTile(
              leading: Icon(h.isContent ? Icons.subject : Icons.description),
              title: Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: h.isContent
                  ? Text(
                      'سطر ${h.line}: ${h.snippet}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      h.path,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                    ),
              onTap: () => close(context, File(h.path)),
            );
          },
        );
      },
    );
  }

  Future<List<SearchHit>> _run() async {
    final root = await buildFileTree(rootPath);
    return _service.search(root: root, query: query);
  }
}