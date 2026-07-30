class UserModel {
  final int id;
  final String email;
  final String username;
  final String? name;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.name,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }
}

class AuthResponse {
  final String access;
  final String refresh;
  final UserModel user;

  AuthResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      access: json['access'],
      refresh: json['refresh'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
