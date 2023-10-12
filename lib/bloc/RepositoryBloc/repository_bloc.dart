import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_event.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_state.dart';
import 'package:github_repos/repository/repository.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final RepositoryRepository repositoryRepository;

  RepositoryBloc({required this.repositoryRepository})
      : super(RepositoryInitial()) {
    on<SearchRepositories>(_onSearchRepositories);
    on<FetchNextPage>(_onFetchNextPage);
    on<RefreshRepositories>(_onRefreshRepositories);
  }

  Future<void> _onSearchRepositories(
    SearchRepositories event,
    Emitter<RepositoryState> emit,
  ) async {
    emit(RepositoryLoading());
    try {
      final repositories =
          await repositoryRepository.searchRepositories(event.query, page: 1);
      repositories.sort((a, b) => a.name.compareTo(b.name));
      final hasMore = repositories.isNotEmpty;
      emit(RepositoryLoaded(repositories, 1, hasMore));
    } catch (e) {
      emit(RepositoryError(e.toString()));
    }
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<RepositoryState> emit,
  ) async {
    if (state is RepositoryLoaded) {
      final currentState = state as RepositoryLoaded;
      if (currentState.hasMore) {
        try {
          emit(RepositoryLoadingNextPage(currentState.repositories));
          final nextPageRepositories =
              await repositoryRepository.searchRepositories(
            event.query,
            page: currentState.currentPage + 1,
          );
          final hasMore = nextPageRepositories.isNotEmpty;
          final allRepositories = List.of(currentState.repositories)
            ..addAll(nextPageRepositories);
          emit(RepositoryLoaded(
              allRepositories, currentState.currentPage + 1, hasMore));
        } catch (e) {
          emit(RepositoryLoaded(currentState.repositories,
              currentState.currentPage, currentState.hasMore));
        }
      }
    }
  }

  Future<void> _onRefreshRepositories(
    RefreshRepositories event,
    Emitter<RepositoryState> emit,
  ) async {
    try {
      final repositories =
          await repositoryRepository.searchRepositories(event.query);
      emit(RepositoryLoaded(repositories, 1, repositories.isNotEmpty));
    } catch (e) {
      emit(const RepositoryError("Failed to refresh repositories"));
    }
  }
}
