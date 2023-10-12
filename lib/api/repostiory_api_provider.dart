import 'dart:convert';
import 'package:github_repos/model/issue.dart';
import 'package:github_repos/model/repository.dart';
import 'package:http/http.dart' as http;

/// [RepositoryApiProvider] is a class responsible for fetching data
/// from the GitHub API. It fetches both repositories and issues.
class RepositoryApiProvider {
  /// [baseUrl] is the base URL for the GitHub API.
  final String baseUrl = 'https://api.github.com';

  /// [fetchRepositories] is a method that fetches repositories from the GitHub API.
  /// It takes a [query] string to search for repositories and an optional [page] parameter
  /// to fetch a specific page of the search results.
  ///
  /// It returns a [Future] that resolves to a list of [Repository] objects.
  /// If the HTTP request fails, or if the server responds with an error status,
  /// an exception is thrown.
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

  /// [fetchIssues] is a method that fetches issues for a specific repository from the GitHub API.
  /// It takes [owner] and [repo] as parameters to identify the repository and an optional [page] parameter
  /// to fetch a specific page of issues.
  ///
  /// It returns a [Future] that resolves to a list of [Issue] objects.
  /// If the HTTP request fails, or if the server responds with an error status,
  /// an exception is thrown.
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
