import 'package:equatable/equatable.dart';

class Issue extends Equatable {
  final int id;
  final String title;
  final String state;
  final String createdAt;
  final String updatedAt;
  final User user;

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

class User extends Equatable {
  final String login;
  final String avatarUrl;

  const User({
    required this.login,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [login, avatarUrl];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
