import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/git_service.dart';

final gitServiceProvider = Provider.family<GitService, String>((ref, path) {
  return GitService(path);
});

final branchesProvider =
    FutureProvider.family<List<BranchInfo>, String>((ref, path) {
  return ref.watch(gitServiceProvider(path)).branches();
});

final currentBranchProvider =
    FutureProvider.family<String?, String>((ref, path) {
  return ref.watch(gitServiceProvider(path)).currentBranch();
});

final statusProvider =
    FutureProvider.family<List<StatusEntry>, String>((ref, path) {
  return ref.watch(gitServiceProvider(path)).status();
});

final commitsProvider =
    FutureProvider.family<List<CommitInfo>, String>((ref, path) {
  return ref.watch(gitServiceProvider(path)).log();
});