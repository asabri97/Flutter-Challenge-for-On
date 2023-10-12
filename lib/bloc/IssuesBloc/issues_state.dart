import 'package:equatable/equatable.dart';
import 'package:github_repos/model/issue.dart';

/// [IssuesState] is an abstract class representing the various states
/// that can be produced within the [IssuesBloc] in response to different events.
abstract class IssuesState extends Equatable {
  const IssuesState();
}

/// [IssuesInitial] is the initial state of the [IssuesBloc].
class IssuesInitial extends IssuesState {
  @override
  List<Object> get props => [];
}

/// [IssuesLoading] represents the state when the [IssuesBloc] is fetching issues.
class IssuesLoading extends IssuesState {
  @override
  List<Object> get props => [];
}

/// [IssuesLoaded] represents the state when the issues have been loaded.
class IssuesLoaded extends IssuesState {
  final List<Issue> issues;
  final int currentPage;
  final bool hasMorePages;

  /// [issues]: List of fetched issues.
  /// [currentPage]: The current page number in pagination.
  /// [hasMorePages]: A boolean flag indicating whether more pages are available.
  const IssuesLoaded(this.issues, this.currentPage, {this.hasMorePages = true});

  @override
  List<Object> get props => [issues, currentPage, hasMorePages];
}

/// [IssuesError] represents the state when an error has occurred.
class IssuesError extends IssuesState {
  final String message;

  /// [message]: A message describing the error.
  const IssuesError(this.message);

  @override
  List<Object> get props => [message];
}
