import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/github_api.dart';
import '../data/github_models.dart';
import '../data/github_settings.dart';

final githubSettingsProvider = Provider((ref) => GithubSettings());

final githubTokenProvider = FutureProvider<String?>((ref) async {
  return ref.watch(githubSettingsProvider).getToken();
});

final githubApiProvider = Provider<GithubApi?>((ref) {
  final tokenAsync = ref.watch(githubTokenProvider);
  return tokenAsync.when(
    data: (token) => token != null && token.isNotEmpty ? GithubApi(token: token) : null,
    loading: () => null,
    error: (_, __) => null,
  );
});

final githubUserProvider = FutureProvider<GithubUser>((ref) async {
  final api = ref.watch(githubApiProvider);
  if (api == null) throw Exception('GitHub Token is missing');
  return api.fetchCurrentUser();
});

final githubReposProvider = FutureProvider<List<GithubRepo>>((ref) async {
  final api = ref.watch(githubApiProvider);
  if (api == null) throw Exception('GitHub Token is missing');
  return api.fetchRepos();
});

final githubIssuesProvider = FutureProvider.family<List<GithubIssue>, ({String owner, String repo})>((ref, params) async {
  final api = ref.watch(githubApiProvider);
  if (api == null) throw Exception('GitHub Token is missing');
  return api.fetchIssues(params.owner, params.repo);
});

final githubContentsProvider = FutureProvider.family<List<GithubContent>, ({String owner, String repo, String path})>((ref, params) async {
  final api = ref.watch(githubApiProvider);
  if (api == null) throw Exception('GitHub Token is missing');
  return api.fetchContents(params.owner, params.repo, params.path);
});
