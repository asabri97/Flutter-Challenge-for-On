import 'package:github_repos/api/repostiory_api_provider.dart';
import 'package:github_repos/model/issue.dart';
import 'package:github_repos/model/repository.dart';

class RepositoryRepository {
  final RepositoryApiProvider _apiProvider = RepositoryApiProvider();

  Future<List<Repository>> searchRepositories(String query,
      {int page = 1}) async {
    final response = await _apiProvider.fetchRepositories(query, page: page);

    return response;
  }

  Future<List<Issue>> getIssues(String owner, String repo,
      {int page = 1}) async {
    return await _apiProvider.fetchIssues(owner, repo, page: page);
  }
}
