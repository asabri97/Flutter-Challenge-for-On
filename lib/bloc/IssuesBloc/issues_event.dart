/// [IssuesEvent] is an abstract class representing the various events
/// that can be processed within the [IssuesBloc].
abstract class IssuesEvent {}

/// [GetIssues] event triggers the fetching of the first page of issues
/// for a specific GitHub repository.
class GetIssues extends IssuesEvent {
  final String owner;
  final String repo;

  /// [owner]: GitHub username who owns the repository.
  /// [repo]: Name of the GitHub repository.
  GetIssues(this.owner, this.repo);
}

/// [FetchNextPageIssues] event triggers the fetching of subsequent pages
/// of issues for a specific GitHub repository.
class FetchNextPageIssues extends IssuesEvent {
  final String owner;
  final String repo;
  final int currentPage;

  /// [owner]: GitHub username who owns the repository.
  /// [repo]: Name of the GitHub repository.
  /// [currentPage]: The current page that has been fetched to determine the next page.
  FetchNextPageIssues({
    required this.owner,
    required this.repo,
    required this.currentPage,
  });
}

/// [RefreshIssues] event triggers the refreshing of the issues list
/// for a specific GitHub repository.
class RefreshIssues extends IssuesEvent {
  final String owner;
  final String repo;

  /// [owner]: GitHub username who owns the repository.
  /// [repo]: Name of the GitHub repository.
  RefreshIssues({
    required this.owner,
    required this.repo,
  });
}
