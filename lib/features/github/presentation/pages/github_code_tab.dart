import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/github_providers.dart';
import '../widgets/file_list_tile.dart';

class GithubCodeTab extends ConsumerStatefulWidget {
  final String owner;
  final String repo;
  const GithubCodeTab({super.key, required this.owner, required this.repo});

  @override
  ConsumerState<GithubCodeTab> createState() => _GithubCodeTabState();
}

class _GithubCodeTabState extends ConsumerState<GithubCodeTab> {
  @override
  Widget build(BuildContext context) {
    final asyncContents = ref.watch(githubContentsProvider((owner: widget.owner, repo: widget.repo, path: '')));

    return asyncContents.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ: $e')),
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => FileListTile(
          item: items[i],
          onTap: () {},
          onDelete: () {},
        ),
      ),
    );
  }
}
