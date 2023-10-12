import 'package:equatable/equatable.dart';
import 'package:github_repos/model/repository.dart';

abstract class RepositoryState extends Equatable {
  const RepositoryState();

  @override
  List<Object> get props => [];
}

class RepositoryInitial extends RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositoryLoaded extends RepositoryState {
  final List<Repository> repositories;
  final int currentPage;
  final bool hasMore;

  const RepositoryLoaded(this.repositories, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [repositories, currentPage, hasMore];
}

class RepositoryError extends RepositoryState {
  final String error;

  const RepositoryError(this.error);

  @override
  List<Object> get props => [error];
}

class RepositoryLoadingNextPage extends RepositoryState {
  final List<Repository> repositories;

  const RepositoryLoadingNextPage(this.repositories);

  @override
  List<Object> get props => [repositories];
}
