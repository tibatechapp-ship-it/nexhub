import 'dart:convert';
import 'package:http/http.dart' as http;
import 'github_models.dart';

class GithubApi {
  final String token;
  final http.Client _client;
  static const String _baseUrl = 'https://api.github.com';

  GithubApi({required this.token, http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'Bearer $token',
        'User-Agent': 'NexHub-App',
      };

  // ═══════════ Repos ═══════════
  Future<List<GithubRepo>> fetchRepos({int page = 1}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/user/repos?page=$page&per_page=30&sort=updated'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GithubRepo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repos: ${response.statusCode}');
    }
  }

  // ═══════════ User ═══════════
  Future<GithubUser> fetchCurrentUser() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/user'), headers: _headers);
    if (response.statusCode == 200) {
      return GithubUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // ═══════════ Issues ═══════════
  Future<List<GithubIssue>> fetchIssues(String owner, String repo) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/repos/$owner/$repo/issues?state=all'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GithubIssue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }

  // ═══════════ Contents ═══════════
  Future<List<GithubContent>> fetchContents(
    String owner,
    String repo, [
    String path = '',
  ]) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/repos/$owner/$repo/contents/$path'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map((json) => GithubContent.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [GithubContent.fromJson(data as Map<String, dynamic>)];
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load contents: ${response.statusCode}');
    }
  }

  // ═══════════ Upload (Create/Update) ═══════════
  Future<void> uploadFile(
    String owner,
    String repo,
    String path,
    String content, {
    String? existingSha,
    String? branch,
  }) async {
    final base64Content = base64Encode(utf8.encode(content));
    final body = <String, dynamic>{
      'message': '${existingSha != null ? "Update" : "Add"} $path via NexHub',
      'content': base64Content,
    };
    if (existingSha != null) body['sha'] = existingSha;
    if (branch != null) body['branch'] = branch;

    final response = await _client.put(
      Uri.parse('$_baseUrl/repos/$owner/$repo/contents/$path'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to upload file: ${response.statusCode}');
    }
  }

  // ═══════════ Delete ═══════════
  Future<void> deleteFile(
    String owner,
    String repo,
    String path,
    String sha, {
    String? branch,
  }) async {
    final body = <String, dynamic>{
      'message': 'Delete $path via NexHub',
      'sha': sha,
    };
    if (branch != null) body['branch'] = branch;

    final response = await _client.delete(
      Uri.parse('$_baseUrl/repos/$owner/$repo/contents/$path'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete file: ${response.statusCode}');
    }
  }
}
