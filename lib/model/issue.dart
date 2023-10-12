import 'package:equatable/equatable.dart';

/// [Issue] is a data class that represents a GitHub issue.
/// It contains information about the issue such as its [id], [title], [state],
/// [createdAt], [updatedAt], and the [user] who created it.
class Issue extends Equatable {
  final int id;
  final String title;
  final String state;
  final String createdAt;
  final String updatedAt;
  final User user;

  /// Creates an instance of [Issue].
  const Issue({
    required this.id,
    required this.title,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  @override
  List<Object?> get props => [id, title, state, createdAt, updatedAt, user];

  /// Creates a new instance of [Issue] from a map.
  /// Used for decoding JSON in a format suitable for constructing an [Issue].
  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'],
      title: json['title'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }
}

/// [User] is a data class that represents a GitHub user.
/// It contains information about the user such as their [login] and [avatarUrl].
class User extends Equatable {
  final String login;
  final String avatarUrl;

  /// Creates an instance of [User].
  const User({
    required this.login,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [login, avatarUrl];

  /// Creates a new instance of [User] from a map.
  /// Used for decoding JSON in a format suitable for constructing a [User].
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
