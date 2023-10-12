abstract class IssuesEvent {}

class GetIssues extends IssuesEvent {
  final String owner;
  final String repo;

  GetIssues(this.owner, this.repo);
}

class FetchNextPageIssues extends IssuesEvent {
  final String owner;
  final String repo;
  final int currentPage;

  FetchNextPageIssues({
    required this.owner,
    required this.repo,
    required this.currentPage,
  });
}

class RefreshIssues extends IssuesEvent {
  final String owner;
  final String repo;

  RefreshIssues({
    required this.owner,
    required this.repo,
  });
}
