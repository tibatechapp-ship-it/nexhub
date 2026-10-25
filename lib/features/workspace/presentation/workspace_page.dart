import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/data/database.dart';
import '../application/workspace_providers.dart';
import 'add_workspace_dialog.dart';

class WorkspacePage extends ConsumerWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final list = ref.watch(workspacesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.workspace)),
      body: list.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (repos) {
          if (repos.isEmpty) {
            return _EmptyState(
              onOpen: () => _openExisting(context, ref),
              onCreate: () => _createNew(context, ref),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: repos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _RepoTile(repo: repos[i]),
            ),
          );
        },
      ),
      floatingActionButton: (list.value?.isNotEmpty ?? false)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'create',
                  onPressed: () => _createNew(context, ref),
                  tooltip: l.createNew,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'open',
                  onPressed: () => _openExisting(context, ref),
                  icon: const Icon(Icons.folder_open),
                  label: Text(l.openExisting),
                ),
              ],
            )
          : null,
    );
  }

  Future<void> _openExisting(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final repo = ref.read(workspaceRepositoryProvider);

    final path = await showDialog<String>(
      context: context,
      builder: (_) => const AddWorkspaceDialog(create: false),
    );
    if (path == null) return;

    final r = await repo.validateOrInit(path);
    if (!r.ok) {
      messenger.showSnackBar(SnackBar(content: Text(_errMsg(l, r.error))));
      return;
    }
    final name = path.split(RegExp(r'[/\\]')).where((e) => e.isNotEmpty).last;
    final id = await repo.add(name: name, path: path);
    router.go('/browser/$id');
  }

  Future<void> _createNew(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final repo = ref.read(workspaceRepositoryProvider);

    final path = await showDialog<String>(
      context: context,
      builder: (_) => const AddWorkspaceDialog(create: true),
    );
    if (path == null) return;

    final r = await repo.validateOrInit(path, create: true);
    if (!r.ok) {
      messenger.showSnackBar(SnackBar(content: Text(r.error ?? l.invalidPath)));
      return;
    }
    final name = path.split(RegExp(r'[/\\]')).where((e) => e.isNotEmpty).last;
    final id = await repo.add(name: name, path: path);
    router.go('/browser/$id');
  }

  String _errMsg(AppLocalizations l, String? code) {
    switch (code) {
      case 'notGitRepo':
        return l.notGitRepo;
      case 'invalidPath':
        return l.invalidPath;
      default:
        return code ?? l.invalidPath;
    }
  }
}

class _RepoTile extends ConsumerWidget {
  const _RepoTile({required this.repo});
  final Repo repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await ref.read(workspaceRepositoryProvider).touch(repo.id);
          if (context.mounted) context.go('/browser/${repo.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.secondaryContainer,
                child: Icon(Icons.folder, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repo.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      repo.path,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l.removeWorkspace,
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    ref.read(workspaceRepositoryProvider).remove(repo.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onOpen, required this.onCreate});
  final VoidCallback onOpen;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_open, size: 72),
            const SizedBox(height: 16),
            Text(l.noWorkspaces, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.folder_open),
              label: Text(l.openExisting),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(l.createNew),
            ),
          ],
        ),
      ),
    );
  }
}