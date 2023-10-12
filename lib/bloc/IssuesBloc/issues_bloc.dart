import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/repository/repository.dart';
import 'issues_event.dart';
import 'issues_state.dart';

/// [IssuesBloc] manages the state of GitHub issues based on various events.
/// It handles fetching, refreshing, and paginating through GitHub issues.
///
/// It listens to [IssuesEvent]s and produces [IssuesState]s.
class IssuesBloc extends Bloc<IssuesEvent, IssuesState> {
  final RepositoryRepository repositoryRepository;

  /// Creates an instance of [IssuesBloc].
  ///
  /// [repositoryRepository] provides methods to fetch GitHub issues.
  IssuesBloc({required this.repositoryRepository}) : super(IssuesInitial()) {
    on<GetIssues>(_onGetIssues);
    on<FetchNextPageIssues>(_onFetchNextPageIssues);
    on<RefreshIssues>(_onRefreshIssues);
  }

  /// [_onGetIssues] fetches GitHub issues when [GetIssues] event is received.
  ///
  /// It emits [IssuesLoading] state while fetching issues and once the issues
  /// are fetched, it emits [IssuesLoaded] state with fetched issues and the
  /// current page. If an error occurs during the fetch, it emits [IssuesError]
  /// state with an error message.
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

  /// [_onFetchNextPageIssues] fetches the next page of GitHub issues when
  /// [FetchNextPageIssues] event is received.
  ///
  /// If the current state is [IssuesLoaded] and more pages are available,
  /// it fetches the next page of issues and emits [IssuesLoaded] state with
  /// the accumulated issues and the updated page number. If an error occurs
  /// during the fetch, it emits [IssuesError] state with an error message.
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

  /// [_onRefreshIssues] refreshes the GitHub issues when [RefreshIssues]
  /// event is received.
  ///
  /// It fetches the first page of issues and emits [IssuesLoaded] state with
  /// the fetched issues and resets the page number to 1. If an error occurs
  /// during the fetch, it emits [IssuesError] state with an error message.
  Future<void> _onRefreshIssues(
    RefreshIssues event,
    Emitter<IssuesState> emit,
  ) async {
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
}
