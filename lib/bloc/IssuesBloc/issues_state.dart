import 'package:equatable/equatable.dart';
import 'package:github_repos/model/issue.dart';

abstract class IssuesState extends Equatable {
  const IssuesState();
}

class IssuesInitial extends IssuesState {
  @override
  List<Object> get props => [];
}

class IssuesLoading extends IssuesState {
  @override
  List<Object> get props => [];
}

class IssuesLoaded extends IssuesState {
  final List<Issue> issues;
  final int currentPage;
  final bool hasMorePages;

  const IssuesLoaded(this.issues, this.currentPage, {this.hasMorePages = true});

  @override
  List<Object> get props => [issues, currentPage, hasMorePages];
}

class IssuesError extends IssuesState {
  final String message;

  const IssuesError(this.message);

  @override
  List<Object> get props => [message];
}
