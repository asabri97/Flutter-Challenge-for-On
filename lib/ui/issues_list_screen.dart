import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/bloc/IssuesBloc/issues_bloc.dart';
import 'package:github_repos/bloc/IssuesBloc/issues_event.dart';
import 'package:github_repos/bloc/IssuesBloc/issues_state.dart';
import 'package:github_repos/model/repository.dart';
import 'package:github_repos/repository/repository.dart';
import 'package:intl/intl.dart';

class IssueListScreen extends StatefulWidget {
  final Repository repository;

  const IssueListScreen({super.key, required this.repository});

  @override
  IssueListScreenState createState() => IssueListScreenState();
}

class IssueListScreenState extends State<IssueListScreen> {
  late IssuesBloc _issuesBloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _issuesBloc = IssuesBloc(
      repositoryRepository: RepositoryRepository(),
    );
    _issuesBloc.add(GetIssues(
      widget.repository.owner.login,
      widget.repository.name,
    ));
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${widget.repository.name} Issues'),
      ),
      body: BlocProvider(
          create: (context) => _issuesBloc,
          child: BlocBuilder<IssuesBloc, IssuesState>(
            builder: (context, state) {
              if (state is IssuesLoaded) {
                if (state.issues.isEmpty) {
                  return const Center(
                    child: Text(
                      'No open issues found',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.white,
                        );
                      },
                      controller: _scrollController,
                      itemCount: state.issues.length,
                      itemBuilder: (context, index) {
                        final issue = state.issues[index];
                        return ListTile(
                          title: Text(
                            issue.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              formatDateString(issue.createdAt),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              } else if (state is IssuesError) {
                return const Center(
                  child: Text(
                    'Error loading issues',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              } else {
                // Loading state or any other state handling can go here
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
            },
          )),
    );
  }

  Future<void> _onRefresh() async {
    _issuesBloc.add(RefreshIssues(
      owner: widget.repository.owner.login,
      repo: widget.repository.name,
    ));
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _issuesBloc.add(FetchNextPageIssues(
        owner: widget.repository.owner.login,
        repo: widget.repository.name,
        currentPage: 1,
      ));
    }
  }

  @override
  void dispose() {
    _issuesBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateString(String inputString) {
    DateTime parsedDateTime = DateTime.parse(inputString);
    DateFormat desiredFormat = DateFormat('dd MMM yyyy H:mm');
    String formattedDate = desiredFormat.format(parsedDateTime);
    return formattedDate;
  }
}
