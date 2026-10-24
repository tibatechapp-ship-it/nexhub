import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../git/application/git_providers.dart';

class BranchesSheet extends ConsumerWidget {
  const BranchesSheet({required this.repoPath, super.key});
  final String repoPath;

  static Future<void> show(BuildContext context, String repoPath) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BranchesSheet(repoPath: repoPath),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branches = ref.watch(branchesProvider(repoPath));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.account_tree_outlined),
                  const SizedBox(width: 8),
                  Text('الفروع', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _create(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('جديد'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: branches.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text('لا فروع'));
                  }
                  return ListView(
                    controller: scroll,
                    children: [
                      for (final b in list)
                        ListTile(
                          leading: Icon(
                            b.isCurrent
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: b.isCurrent
                                ? Colors.green
                                : Theme.of(context).colorScheme.outline,
                          ),
                          title: Text(
                            b.name,
                            textDirection: TextDirection.ltr,
                          ),
                          subtitle: b.isRemote ? const Text('remote') : null,
                          onTap: b.isCurrent || b.isRemote
                              ? null
                              : () async {
                                  final git =
                                      ref.read(gitServiceProvider(repoPath));
                                  final r = await git.checkout(b.name);
                                  if (!context.mounted) return;
                                  if (r.ok) {
                                    ref.invalidate(
                                        currentBranchProvider(repoPath));
                                    ref.invalidate(branchesProvider(repoPath));
                                    ref.invalidate(statusProvider(repoPath));
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(r.stderr),
                                    ));
                                  }
                                },
                          trailing: b.isCurrent || b.isRemote
                              ? null
                              : PopupMenuButton<String>(
                                  onSelected: (v) async {
                                    if (v == 'checkout') {
                                      final git = ref
                                          .read(gitServiceProvider(repoPath));
                                      final r = await git.checkout(b.name);
                                      if (!context.mounted) return;
                                      if (r.ok) {
                                        ref.invalidate(
                                            currentBranchProvider(repoPath));
                                        ref.invalidate(
                                            branchesProvider(repoPath));
                                        ref.invalidate(
                                            statusProvider(repoPath));
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(r.stderr),
                                        ));
                                      }
                                    } else if (v == 'merge') {
                                      final git = ref
                                          .read(gitServiceProvider(repoPath));
                                      final r = await git.mergeBranch(b.name);
                                      if (!context.mounted) return;
                                      if (r.ok) {
                                        ref.invalidate(
                                            branchesProvider(repoPath));
                                        ref.invalidate(
                                            commitsProvider(repoPath));
                                        ref.invalidate(
                                            statusProvider(repoPath));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('تم دمج ${b.name}'),
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(r.stderr),
                                        ));
                                      }
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'checkout',
                                        child: Text('تبديل')),
                                    PopupMenuItem(
                                        value: 'merge',
                                        child: Text('دمج في الحالي')),
                                  ],
                                ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('فرع جديد'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'اسم الفرع',
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.ltr,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final git = ref.read(gitServiceProvider(repoPath));
    final r = await git.createBranch(name);
    if (!context.mounted) return;
    if (r.ok) {
      ref.invalidate(branchesProvider(repoPath));
      ref.invalidate(currentBranchProvider(repoPath));
      ref.invalidate(statusProvider(repoPath));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(r.stderr)));
    }
  }
}