import 'package:equatable/equatable.dart';
import 'package:github_repos/model/repository.dart';

/// [RepositoryState] represents the different states of the [RepositoryBloc].
/// It can be in an initial, loading, loaded, or error state.
abstract class RepositoryState extends Equatable {
  const RepositoryState();

  @override
  List<Object> get props => [];
}

/// [RepositoryInitial] is the initial state of the [RepositoryBloc].
class RepositoryInitial extends RepositoryState {}

/// [RepositoryLoading] is a state indicating that the [RepositoryBloc] is
/// loading the repository data.
class RepositoryLoading extends RepositoryState {}

/// [RepositoryLoaded] is a state indicating that the [RepositoryBloc] has
/// loaded the repository data.
class RepositoryLoaded extends RepositoryState {
  final List<Repository> repositories;
  final int currentPage;
  final bool hasMore;

  /// [repositories]: The list of loaded repositories.
  /// [currentPage]: The current page of the repository list.
  /// [hasMore]: A flag indicating whether more repositories can be loaded.
  const RepositoryLoaded(this.repositories, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [repositories, currentPage, hasMore];
}

/// [RepositoryError] is a state indicating that an error has occurred
/// while loading the repository data.
class RepositoryError extends RepositoryState {
  final String error;

  /// [error]: A message describing the error that occurred.
  const RepositoryError(this.error);

  @override
  List<Object> get props => [error];
}

/// [RepositoryLoadingNextPage] is a state indicating that the [RepositoryBloc]
/// is loading the next page of repository data.
class RepositoryLoadingNextPage extends RepositoryState {
  final List<Repository> repositories;

  /// [repositories]: The list of currently loaded repositories.
  const RepositoryLoadingNextPage(this.repositories);

  @override
  List<Object> get props => [repositories];
}
