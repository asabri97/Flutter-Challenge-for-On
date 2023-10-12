import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_bloc.dart';
import 'package:github_repos/repository/repository.dart';
import 'package:github_repos/ui/repository_search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GitHub Repository Search',
      home: BlocProvider(
        create: (context) =>
            RepositoryBloc(repositoryRepository: RepositoryRepository()),
        child: const RepositorySearchScreen(),
      ),
    );
  }
}
