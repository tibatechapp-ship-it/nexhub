import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../git/application/git_providers.dart';
import '../../nexus_chat/presentation/nexus_chat_sheet.dart';
import 'history_page.dart' show DiffText;

class CommitsPage extends ConsumerWidget {
  const CommitsPage({required this.repoPath, super.key});
  final String repoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commits = ref.watch(commitsProvider(repoPath));

    return Scaffold(
      appBar: AppBar(title: const Text('السجل الكامل')),
      body: commits.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context).historyEmpty),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final c = list[i];
              return ListTile(
                leading: const Icon(Icons.commit),
                title: Text(c.subject.isEmpty ? '(بدون رسالة)' : c.subject),
                subtitle: Text('${c.author} · ${c.shortHash} · ${c.date}'),
                trailing: IconButton(
                  icon: const Icon(Icons.psychology, color: Colors.purpleAccent),
                  tooltip: 'شرح هذا الـ commit',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => NexusChatSheet(
                        repoPath: repoPath,
                        initialMessage:
                            'Explain the changes in commit ${c.hash}. '
                            'Focus on WHY these lines were modified using '
                            'the get_commit_diff tool.',
                      ),
                    );
                  },
                ),
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => Dialog(
                    insetPadding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 1000,
                        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
                      ),
                      child: FutureBuilder<String>(
                        future: ref
                            .read(gitServiceProvider(repoPath))
                            .commitDiff(c.hash),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: DiffText(diff: snap.data!),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}