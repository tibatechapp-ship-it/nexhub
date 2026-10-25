import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../application/browser_providers.dart';
import '../../health/presentation/health_sheet.dart';
import '../../stats/presentation/stats_page.dart';
import '../../journal/presentation/journal_sheet.dart';
import '../../review/presentation/review_sheet.dart';
import '../../status/presentation/branches_sheet.dart';
import '../../status/presentation/status_sheet.dart';
import 'file_tree_widget.dart';
import 'file_viewer_widget.dart';
import 'search_delegate.dart';

class BrowserPage extends ConsumerStatefulWidget {
  const BrowserPage({required this.workspaceId, super.key});
  final int workspaceId;

  @override
  ConsumerState<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends ConsumerState<BrowserPage> {
  File? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repoAsync = ref.watch(currentRepoProvider(widget.workspaceId));

    return repoAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (repo) {
        if (repo == null) {
          return Scaffold(body: Center(child: Text(l.invalidPath)));
        }
        final treeAsync = ref.watch(fileTreeProvider(repo.path));
        final wide = MediaQuery.sizeOf(context).width >= 900;

        return Scaffold(
          appBar: AppBar(
            title: Text(repo.name),
            actions: [
              IconButton(
                tooltip: 'مراجعة محلية',
                icon: const Icon(Icons.compare_arrows),
                onPressed: () => ReviewSheet.show(context, repo.path),
              ),
              IconButton(
                tooltip: 'المذكرات',
                icon: const Icon(Icons.menu_book_outlined),
                onPressed: () => JournalSheet.show(context, repoPath: repo.path),
              ),
              IconButton(
                tooltip: 'فحص صحي',
                icon: const Icon(Icons.health_and_safety_outlined),
                onPressed: () => HealthSheet.show(context, repo.path),
              ),
              IconButton(
                tooltip: 'إحصائياتي',
                icon: const Icon(Icons.insights_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StatsPage(repoPath: repo.path),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'الفروع',
                icon: const Icon(Icons.account_tree_outlined),
                onPressed: () => BranchesSheet.show(context, repo.path),
              ),
              IconButton(
                tooltip: 'الحالة',
                icon: const Icon(Icons.change_circle_outlined),
                onPressed: () => StatusSheet.show(context, repo.path),
              ),
              IconButton(
                tooltip: l.search,
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final f = await showSearch<File?>(
                    context: context,
                    delegate: FileSearchDelegate(rootPath: repo.path),
                  );
                  if (f != null) setState(() => _selected = f);
                },
              ),
            ],
          ),
          body: treeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (root) {
              if (wide) {
                return Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: FileTreeWidget(
                        root: root,
                        onFileSelected: (f) => setState(() => _selected = f),
                        selectedPath: _selected?.path,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: FileViewerWidget(file: _selected)),
                  ],
                );
              }
              return _selected == null
                  ? FileTreeWidget(
                      root: root,
                      onFileSelected: (f) => setState(() => _selected = f),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => setState(() => _selected = null),
                              ),
                              Expanded(
                                child: Text(
                                  _selected!.path
                                      .split(RegExp(r'[/\\]'))
                                      .last,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: FileViewerWidget(file: _selected)),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}