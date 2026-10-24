import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/database.dart';
import '../../workspace/application/workspace_providers.dart';
import '../domain/file_node.dart';

final currentRepoProvider = FutureProvider.family<Repo?, int>((ref, id) {
  return ref.watch(workspaceRepositoryProvider).byId(id);
});

final fileTreeProvider = FutureProvider.family<FolderNode, String>((ref, path) {
  return buildFileTree(path);
});

final selectedFileProvider = StateProvider.family<String?, int>((ref, _) => null);