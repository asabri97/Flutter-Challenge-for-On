import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:github_repos/ui/repository_search_screen.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_bloc.dart';
import 'package:github_repos/bloc/RepositoryBloc/repository_state.dart';
import 'package:github_repos/model/repository.dart';
import 'package:mocktail/mocktail.dart';
import '../mocks.dart';

void main() {
  // [MockRepositoryBloc] will be used to simulate the [RepositoryBloc] behavior during testing.
  late MockRepositoryBloc mockRepositoryBloc;

  // [setUp] is run before every single test to initialize the [mockRepositoryBloc].
  setUp(() {
    mockRepositoryBloc = MockRepositoryBloc();
  });

  // Define a group of tests that will test the behavior of the [RepositorySearchScreen] widget.
  testWidgets('displays repository when RepositoryLoaded state is emitted',
      (WidgetTester tester) async {
    // Define a list of [Repository] objects to be used in the test.
    final repositories = [
      const Repository(
        id: 1,
        name: 'Test Repo',
        description: 'This is a test repository',
        htmlUrl: 'http://github.com/test/test_repo',
        owner: Owner(
          login: 'testuser',
          avatarUrl: 'http://github.com/avatars/testuser.png',
        ),
      ),
    ];

    // Stub the [state] of the [mockRepositoryBloc] to return a specific [RepositoryLoaded] state.
    when(() => mockRepositoryBloc.state).thenReturn(
      RepositoryLoaded(repositories, 1, true),
    );

    // Stub the stream of states emitted from the [mockRepositoryBloc].
    whenListen(
      mockRepositoryBloc,
      Stream.fromIterable([
        RepositoryLoaded(repositories, 1, true),
      ]),
    );

    // Build the widget tree for testing and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RepositoryBloc>.value(
          value: mockRepositoryBloc,
          child: const RepositorySearchScreen(),
        ),
      ),
    );

    // Allow animations and frame changes to settle.
    await tester.pumpAndSettle();

    // Assert that a widget containing the expected text is found in the widget tree.
    expect(find.text('Test Repo'), findsOneWidget);
  });
}
