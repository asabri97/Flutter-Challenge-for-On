/// `RepositorySearchScreen` - A screen that allows users to search for GitHub repositories.
///
/// This screen provides a search bar for user input and displays a list of repositories
/// that match the search query. It also supports functionalities like pull-to-refresh
/// and infinite scrolling to enhance user experience.

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
      body: Column(children: [
        _buildSearchBar(),
        Expanded(child: _buildRepositoryList())
      ]),
    );
  }

  /// `_onRefresh` - Refreshes the repository list.
  ///
  /// This method is triggered when the user performs a pull-to-refresh action.
  /// It sends a `RefreshRepositories` event to the `RepositoryBloc` to fetch
  /// the repositories again based on the current search query.
  Future<void> _onRefresh() async {
    context
        .read<RepositoryBloc>()
        .add(RefreshRepositories(query: _searchController.text));
  }

  /// `_onScroll` - Handles the scroll event of the repository list.
  ///
  /// This method listens for scroll events and determines when the user has scrolled
  /// near the bottom of the list. When this happens, it sends a `FetchNextPage` event
  /// to the `RepositoryBloc` to load more repositories if available.
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

  /// `_buildSearchBar` - Builds and returns the search bar widget.
  ///
  /// The search bar allows users to input a query string, which is used to search
  /// for GitHub repositories. The search is triggered once the input length is >= 4.
  Widget _buildSearchBar() {
    return TextField(
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
    );
  }

  /// `_buildRepositoryList` - Builds and returns the repository list widget.
  ///
  /// The repository list displays the repositories fetched based on the search query.
  /// It also handles various states like loading, loaded, and error to provide feedback
  /// to the user and enhance user experience.
  Widget _buildRepositoryList() {
    return BlocBuilder<RepositoryBloc, RepositoryState>(
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
          if (repositories.isEmpty) {
            return const Center(
              child: Text(
                'No repositories found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
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
        return const SizedBox.shrink();
      },
    );
  }
}
