import 'package:github_repos/api/repostiory_api_provider.dart';
import 'package:github_repos/model/issue.dart';
import 'package:github_repos/model/repository.dart';

/// [RepositoryRepository] serves as a middleman between the API provider and the BLoC.
/// It uses the [_apiProvider] to fetch data from the API and then passes the data to the BLoC.
class RepositoryRepository {
  /// An instance of [RepositoryApiProvider] to perform API requests.
  final RepositoryApiProvider _apiProvider = RepositoryApiProvider();

  /// Fetches a list of repositories based on the provided [query] and [page].
  ///
  /// [query]: A string that represents the search query.
  /// [page]: An optional parameter that represents the page number to fetch. Defaults to 1.
  ///
  /// Returns a [Future] that resolves to a list of [Repository] objects.
  Future<List<Repository>> searchRepositories(String query,
      {int page = 1}) async {
    final response = await _apiProvider.fetchRepositories(query, page: page);

    return response;
  }

  /// Fetches a list of issues for a specific repository.
  ///
  /// [owner]: A string that represents the owner of the repository.
  /// [repo]: A string that represents the name of the repository.
  /// [page]: An optional parameter that represents the page number to fetch. Defaults to 1.
  ///
  /// Returns a [Future] that resolves to a list of [Issue] objects.
  Future<List<Issue>> getIssues(String owner, String repo,
      {int page = 1}) async {
    return await _apiProvider.fetchIssues(owner, repo, page: page);
  }
}
