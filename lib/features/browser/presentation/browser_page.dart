import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../application/browser_providers.dart';
import '../../health/presentation/health_sheet.dart';
import '../../stats/presentation/stats_page.dart';
import '../../journal/presentation/journal_sheet.dart';
import '../../review/presentation/review_sheet.dart';
import '../../status/presentation/branches_sheet.dart';
import '../../status/presentation/status_sheet.dart';
import '../../terminal/presentation/terminal_page.dart';
import '../../sync/presentation/sync_sheet.dart';
import '../../repo_features/presentation/repo_features_sheet.dart';
import 'file_tree_widget.dart';
import 'file_viewer_widget.dart';
import 'search_delegate.dart';
import '../../nexus_chat/presentation/nexus_chat_sheet.dart';

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
              // UX audit N-2: the hub AppBar had 8 icon buttons that overflow
              // every screen under 900px. Frequent actions stay visible; the
              // rest move here — including previously unreachable features
              // (Terminal, Sync, Repo features) that had no entry point.
              IconButton(
                tooltip: 'الحالة والالتزام',
                icon: const Icon(Icons.change_circle_outlined),
                onPressed: () => StatusSheet.show(context, repo.path),
              ),
              IconButton(
                tooltip: 'Nexus Agent',
                icon: const Icon(Icons.auto_awesome),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NexusChatSheet(repoPath: repo.path),
                ),
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
              PopupMenuButton<String>(
                tooltip: 'المزيد من الأدوات',
                icon: const Icon(Icons.more_vert),
                onSelected: (v) {
                  switch (v) {
                    case 'review':
                      ReviewSheet.show(context, repo.path);
                    case 'journal':
                      JournalSheet.show(context, repoPath: repo.path);
                    case 'health':
                      HealthSheet.show(context, repo.path);
                    case 'stats':
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => StatsPage(repoPath: repo.path),
                        ),
                      );
                    case 'branches':
                      BranchesSheet.show(context, repo.path);
                    case 'terminal':
                      TerminalPage.open(context, repo.path);
                    case 'sync':
                      SyncSheet.show(context, repo.path);
                    case 'features':
                      RepoFeaturesSheet.show(context, widget.workspaceId);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                      value: 'review',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.compare_arrows),
                          title: Text('مراجعة محلية'))),
                  PopupMenuItem(
                      value: 'branches',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.account_tree_outlined),
                          title: Text('الفروع'))),
                  PopupMenuItem(
                      value: 'journal',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.menu_book_outlined),
                          title: Text('المذكرات'))),
                  PopupMenuItem(
                      value: 'terminal',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.terminal),
                          title: Text('الطرفية'))),
                  PopupMenuItem(
                      value: 'sync',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.sync),
                          title: Text('مزامنة (pull/push)'))),
                  PopupMenuItem(
                      value: 'features',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.tune),
                          title: Text('ميزات المستودع'))),
                  PopupMenuItem(
                      value: 'health',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.health_and_safety_outlined),
                          title: Text('فحص صحي'))),
                  PopupMenuItem(
                      value: 'stats',
                      child: ListTile(
                          dense: true,
                          leading: Icon(Icons.insights_outlined),
                          title: Text('إحصائياتي'))),
                ],
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
                                tooltip: 'رجوع لقائمة الملفات',
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