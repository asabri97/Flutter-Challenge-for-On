import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_bloc.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_event.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_state.dart';
import 'package:github_repos/ui/issues_list_screen.dart';

class RepositorySearchScreen extends StatefulWidget {
  const RepositorySearchScreen({super.key});

  @override
  RepositorySearchScreenState createState() => RepositorySearchScreenState();
}

class RepositorySearchScreenState extends State<RepositorySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'GitHub Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 24),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 5.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintStyle: const TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Search repositories...',
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () => _searchController.clear(),
              ),
            ),
            onChanged: (query) {
              if (query.length >= 4) {
                final bloc = context.read<RepositoryBloc>();
                bloc.add(SearchRepositories(query));
              }
            },
          ),
          Expanded(child: BlocBuilder<RepositoryBloc, RepositoryState>(
            builder: (context, state) {
              if (state is RepositoryLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (state is RepositoryLoaded ||
                  state is RepositoryLoadingNextPage) {
                final repositories = (state is RepositoryLoaded)
                    ? state.repositories
                    : (state as RepositoryLoadingNextPage).repositories;

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Divider(
                          color: Colors.white,
                        ),
                      );
                    },
                    controller: _scrollController,
                    itemCount: repositories.length +
                        (state is RepositoryLoadingNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= repositories.length) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      }
                      final repository = repositories[index];
                      return ListTile(
                        title: Text(
                          repository.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          repository.description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IssueListScreen(
                                repository: repository,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              } else if (state is RepositoryError) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox
                  .shrink(); // Return an empty widget if none of the above states match
            },
          )),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    context
        .read<RepositoryBloc>()
        .add(RefreshRepositories(query: _searchController.text));
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      final state = context.read<RepositoryBloc>().state;
      if (state is RepositoryLoaded && state.hasMore) {
        context.read<RepositoryBloc>().add(
              FetchNextPage(
                query: _searchController.text,
                currentPage: state.currentPage,
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
