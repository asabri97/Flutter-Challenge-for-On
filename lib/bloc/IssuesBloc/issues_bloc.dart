import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/repository/repository.dart';
import 'issues_event.dart';
import 'issues_state.dart';

class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  final RepositoryRepository repositoryRepository;

  IssuesBloc({required this.repositoryRepository}) : super(IssuesInitial()) {
    on<GetIssues>(_onGetIssues);
    on<FetchNextPageIssues>(_onFetchNextPageIssues);
    on<RefreshIssues>(_onRefreshIssues);
  }

  Future<void> _onGetIssues(
    GetIssues event,
    Emitter<IssuesState> emit,
  ) async {
    emit(IssuesLoading());
    try {
      final issues = await repositoryRepository.getIssues(
        event.owner,
        event.repo,
        page: 1,
      );
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(IssuesLoaded(issues, 1));
    } catch (e) {
      emit(IssuesError(e.toString()));
    }
  }

  // Future<void> _onFetchNextPageIssues(
  //   FetchNextPageIssues event,
  //   Emitter<IssuesState> emit,
  // ) async {
  //   try {
  //     if (state is IssuesLoaded) {
  //       final currentState = state as IssuesLoaded;
  //       final nextPageIssues = await repositoryRepository.getIssues(
  //         event.owner,
  //         event.repo,
  //         page: currentState.currentPage + 1, // Using current page from state
  //       );
  //       final allIssues = List.of(currentState.issues)..addAll(nextPageIssues);
  //       emit(IssuesLoaded(
  //           allIssues, currentState.currentPage + 1)); // Updating page number
  //     }
  //   } catch (e) {
  //     emit(IssuesError(e.toString()));
  //   }
  // }

  Future<void> _onFetchNextPageIssues(
    FetchNextPageIssues event,
    Emitter<IssuesState> emit,
  ) async {
    try {
      if (state is IssuesLoaded && (state as IssuesLoaded).hasMorePages) {
        final nextPageIssues = await repositoryRepository.getIssues(
          event.owner,
          event.repo,
          page: event.currentPage + 1,
        );
        final allIssues = List.of((state as IssuesLoaded).issues)
          ..addAll(nextPageIssues);
        emit(IssuesLoaded(allIssues, event.currentPage + 1,
            hasMorePages: nextPageIssues.isNotEmpty));
      }
    } catch (e) {
      emit(const IssuesError('Failed to load more issues.'));
    }
  }

  Future<void> _onRefreshIssues(
    RefreshIssues event,
    Emitter<IssuesState> emit,
  ) async {
    try {
      final issues = await repositoryRepository.getIssues(
        event.owner,
        event.repo,
        page: 1, // Fetching the first page
      );
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(IssuesLoaded(issues, 1));
    } catch (e) {
      emit(IssuesError(e.toString()));
    }
  }
}
