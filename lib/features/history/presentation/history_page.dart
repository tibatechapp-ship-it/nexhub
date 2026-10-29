import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../git/application/git_providers.dart';
import '../../git/data/git_service.dart';
import '../../journal/presentation/journal_sheet.dart';
import '../../../shared/data/database.dart';
import '../../workspace/application/workspace_providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final repos = ref.watch(workspacesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.navHistory)),
      body: repos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (List<Repo> list) {
          if (list.isEmpty) {
            return Center(child: Text(l.historyEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final repo = list[i];
              return _RepoCommitsCard(repoPath: repo.path, repoName: repo.name);
            },
          );
        },
      ),
    );
  }
}

class _RepoCommitsCard extends ConsumerWidget {
  const _RepoCommitsCard({required this.repoPath, required this.repoName});
  final String repoPath;
  final String repoName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commits = ref.watch(commitsProvider(repoPath));
    final branch = ref.watch(currentBranchProvider(repoPath));
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: scheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.account_tree_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    repoName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                branch.when(
                  data: (b) => b == null
                      ? const SizedBox.shrink()
                      : Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(b, style: const TextStyle(fontSize: 11)),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          commits.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(12),
              child: Text('$e', style: TextStyle(color: scheme.error)),
            ),
            data: (List<CommitInfo> list) {
              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'لا commits بعد',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < list.length && i < 10; i++)
                    _CommitTile(repoPath: repoPath, commit: list[i]),
                  if (list.length > 10)
                    TextButton(
                      onPressed: () => context.go(
                        '/commits/${Uri.encodeComponent(repoPath)}',
                      ),
                      child: const Text('عرض الكل'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CommitTile extends StatelessWidget {
  const _CommitTile({required this.repoPath, required this.commit});
  final String repoPath;
  final CommitInfo commit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.commit, size: 20),
      title: Text(
        commit.subject.isEmpty ? '(بدون رسالة)' : commit.subject,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${commit.author} · ${commit.shortHash} · ${_fmtDate(commit.date)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.menu_book_outlined, size: 20),
        tooltip: 'مذكرات',
        onPressed: () => JournalSheet.show(
          context,
          repoPath: repoPath,
          commitHash: commit.hash,
          commitSubject: commit.subject,
        ),
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _DiffDialog(repoPath: repoPath, commit: commit),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
    if (diff.inDays < 30) return 'قبل ${diff.inDays} ي';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _DiffDialog extends ConsumerWidget {
  const _DiffDialog({required this.repoPath, required this.commit});
  final String repoPath;
  final CommitInfo commit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(gitServiceProvider(repoPath)).commitDiff(commit.hash);
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: wide ? 48 : 12,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1100,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(commit.shortHash),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  tooltip: 'إغلاق',
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  commit.subject,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<String>(
                future: future,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: DiffText(diff: snap.data!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiffText extends StatelessWidget {
  const DiffText({required this.diff, super.key});
  final String diff;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: dark ? Colors.grey.shade300 : Colors.grey.shade900,
    );
    final add = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: dark ? const Color(0xFF8FE388) : const Color(0xFF116329),
      backgroundColor:
          dark ? const Color(0x1A4CAF50) : const Color(0x2266BB6A),
    );
    final del = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: dark ? const Color(0xFFF28B82) : const Color(0xFF82071E),
      backgroundColor:
          dark ? const Color(0x1AF44336) : const Color(0x22FF8182),
    );
    final hunk = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12.5,
      color: dark ? const Color(0xFF7BC7FF) : const Color(0xFF0969DA),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in diff.split('\n'))
          Text(
            line,
            style: line.startsWith('+') && !line.startsWith('+++')
                ? add
                : line.startsWith('-') && !line.startsWith('---')
                    ? del
                    : line.startsWith('@@')
                        ? hunk
                        : base,
          ),
      ],
    );
  }
}