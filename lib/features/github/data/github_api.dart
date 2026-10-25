import 'dart:convert';
import 'package:http/http.dart' as http;
import 'github_models.dart';

class GithubApi {
  final String token;
  final http.Client _client;
  static const String _baseUrl = 'https://api.github.com';

  GithubApi({required this.token, http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'Bearer $token',
        'User-Agent': 'NexHub-App',
      };

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

  Future<GithubUser> fetchCurrentUser() async {
    final response = await _client.get(Uri.parse('$_baseUrl/user'), headers: _headers);
    if (response.statusCode == 200) {
      return GithubUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

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
}
