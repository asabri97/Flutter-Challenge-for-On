import 'dart:convert';
import 'package:github_repos/model/issue.dart';
import 'package:github_repos/model/repository.dart';
import 'package:http/http.dart' as http;

class RepositoryApiProvider {
  final String baseUrl = 'https://api.github.com';

  Future<List<Repository>> fetchRepositories(String query,
      {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/repositories?q=$query&page=$page'),
    );

    if (response.statusCode == 200) {
      List<dynamic> repoJson = json.decode(response.body)['items'];
      return repoJson.map((json) => Repository.fromJson(json)).toList();
    } else if (response.statusCode == 403) {
      throw Exception('Rate limit exceeded');
    } else {
      throw Exception(
          'Failed to load repositories with status code: ${response.statusCode}');
    }
  }

  Future<List<Issue>> fetchIssues(String owner, String repo,
      {int page = 1}) async {
    final response = await http
        .get(Uri.parse('$baseUrl/repos/$owner/$repo/issues?page=$page'));

    if (response.statusCode == 200) {
      List<dynamic> issuesJson = json.decode(response.body);
      return issuesJson.map((json) => Issue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }
}
