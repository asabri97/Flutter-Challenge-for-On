// test/mocks.dart

import 'package:github_repos/bloc/RepositoryBloc/repository_bloc.dart';
import 'package:mocktail/mocktail.dart';

// [MockRepositoryBloc] is a mock class that simulates the behavior of [RepositoryBloc].
// It extends [Mock] and implements [RepositoryBloc], allowing it to be used in tests
// to verify interactions and provide controlled responses from method calls within [RepositoryBloc].
class MockRepositoryBloc extends Mock implements RepositoryBloc {}
