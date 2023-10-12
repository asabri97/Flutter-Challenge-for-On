/// [RepositoryEvent] represents the various events that can be processed
/// by the [RepositoryBloc]. These events guide how the state should change.
abstract class RepositoryEvent {}

/// [SearchRepositories] is an event indicating that the user has initiated
/// a search for repositories with a specific query.
class SearchRepositories extends RepositoryEvent {
  final String query;

  /// [query]: The search term used to find repositories.
  SearchRepositories(this.query);
}

/// [FetchNextPage] is an event indicating that the user has requested
/// to load the next page of repository results.
class FetchNextPage extends RepositoryEvent {
  final String query;
  final int currentPage;

  /// [query]: The search term used to find repositories.
  /// [currentPage]: The current page that user is on.
  FetchNextPage({required this.query, required this.currentPage});
}

/// [RefreshRepositories] is an event indicating that the user has requested
/// to refresh the repository results.
class RefreshRepositories extends RepositoryEvent {
  final String query;

  /// [query]: The search term used to find repositories.
  RefreshRepositories({required this.query});
}
