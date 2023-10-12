import 'package:equatable/equatable.dart';

class Repository extends Equatable {
  final int id;
  final String name;
  final String description;
  final String htmlUrl;
  final Owner owner;

  const Repository({
    required this.id,
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, name, description, htmlUrl, owner];

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      htmlUrl: json['html_url'],
      owner: Owner.fromJson(json['owner']),
    );
  }
}

class Owner extends Equatable {
  final String login;
  final String avatarUrl;

  const Owner({
    required this.login,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [login, avatarUrl];

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
