import 'package:flutter_test/flutter_test.dart';
import 'package:github_repos/model/issue.dart';

void main() {
  // This [group] bundles together tests related to the [Issue] model.
  group('Issue Model', () {
    // This [test] verifies that the [Issue.fromJson] method correctly creates an [Issue] instance.
    test('fromJson should create Issue from JSON', () {
      // [json] is a Map that mimics a JSON object received from an API, representing an [Issue].
      final json = {
        'id': 1,
        'title': 'Test Issue',
        'state': 'open',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
        'user': {
          'login': 'user1',
          'avatar_url': 'http://avatar.url',
        },
      };

      // [issue] is created by calling [fromJson] and passing the [json] object.
      final issue = Issue.fromJson(json);

      // The following [expect] statements verify that the [issue] object was created correctly.
      // They check that the properties of [issue] match the expected values based on [json].
      expect(issue.id, 1);
      expect(issue.title, 'Test Issue');
      expect(issue.state, 'open');
      expect(issue.createdAt, '2023-01-01T00:00:00Z');
      expect(issue.updatedAt, '2023-01-01T00:00:00Z');
      expect(issue.user.login, 'user1');
      expect(issue.user.avatarUrl, 'http://avatar.url');
    });
  });
}
