import 'package:equatable/equatable.dart';

/// [Repository] is a data class that represents a GitHub repository.
/// It contains information about the repository such as its [id], [name],
/// [description], [htmlUrl], and the repository [owner].
class Repository extends Equatable {
  final int id;
  final String name;
  final String description;
  final String htmlUrl;
  final Owner owner;

  /// Creates an instance of [Repository].
  const Repository({
    required this.id,
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.owner,
  });

  @override
  List<Object?> get props => [id, name, description, htmlUrl, owner];

  /// Creates a new instance of [Repository] from a map.
  /// Used for decoding JSON in a format suitable for constructing a [Repository].
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

/// [Owner] is a data class that represents the owner of a GitHub repository.
/// It contains information about the owner such as their [login] and [avatarUrl].
class Owner extends Equatable {
  final String login;
  final String avatarUrl;

  /// Creates an instance of [Owner].
  const Owner({
    required this.login,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [login, avatarUrl];

  /// Creates a new instance of [Owner] from a map.
  /// Used for decoding JSON in a format suitable for constructing an [Owner].
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}
