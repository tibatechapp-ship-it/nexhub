import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repo_features_repository.dart';

class RepoFeaturesSheet extends ConsumerWidget {
  const RepoFeaturesSheet({required this.repoId, super.key});
  final int repoId;

  static Future<void> show(BuildContext context, int repoId) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => RepoFeaturesSheet(repoId: repoId),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch(repoFeaturesProvider(repoId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, scroll) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.tune),
                  const SizedBox(width: 8),
                  Text('ميزات المستودع',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    tooltip: 'إغلاق',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'كل شيء مُعطّل افتراضياً. فعّل ما تحتاجه فقط — الميزات '
                'المعطّلة لا تظهر ولا تستهلك أي شيء.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Divider(),
            Expanded(
              child: features.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (map) => ListView(
                  controller: scroll,
                  children: [
                    for (final k in repoFeatureKeys)
                      SwitchListTile(
                        title: Text(repoFeatureLabels[k] ?? k),
                        value: map[k] ?? false,
                        onChanged: (v) => ref
                            .read(repoFeaturesRepositoryProvider)
                            .toggle(repoId, k, v),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}