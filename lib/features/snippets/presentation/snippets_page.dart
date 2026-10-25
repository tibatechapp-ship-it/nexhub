import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/utils/arabic_normalizer.dart';
import '../../../shared/data/database.dart';
import '../data/snippets_repository.dart';
import 'snippet_editor_dialog.dart';

class SnippetsPage extends ConsumerStatefulWidget {
  const SnippetsPage({super.key});

  @override
  ConsumerState<SnippetsPage> createState() => _SnippetsPageState();
}

class _SnippetsPageState extends ConsumerState<SnippetsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final list = ref.watch(snippetsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navSnippets),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: list.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (snips) {
          final q = _query.trim();
          final filtered = q.isEmpty
              ? snips
              : snips.where((s) {
                  return arabicContains(s.title, q) ||
                      arabicContains(s.body, q) ||
                      arabicContains(s.tags, q);
                }).toList();
          if (filtered.isEmpty) {
            return Center(child: Text(l.snippetsEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _SnippetTile(snippet: filtered[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SnippetEditorDialog.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SnippetTile extends ConsumerWidget {
  const _SnippetTile({required this.snippet});
  final Snippet snippet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => SnippetEditorDialog.show(context, existing: snippet),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      snippet.language,
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSecondaryContainer,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      snippet.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    tooltip: 'نسخ',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: snippet.body));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم النسخ')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                snippet.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
                textDirection: TextDirection.ltr,
              ),
              if (snippet.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final t in snippet.tags.split(','))
                      if (t.trim().isNotEmpty)
                        Chip(
                          label: Text(t.trim(),
                              style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                        ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}