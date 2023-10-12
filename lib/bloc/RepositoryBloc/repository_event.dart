abstract class RepositoryEvent {}

class SearchRepositories extends RepositoryEvent {
  final String query;

  SearchRepositories(this.query);
}

class FetchNextPage extends RepositoryEvent {
  final String query;
  final int currentPage;

  FetchNextPage({required this.query, required this.currentPage});
}

class RefreshRepositories extends RepositoryEvent {
  final String query;

  RefreshRepositories({required this.query});
}
