import 'package:caff_shop_app/app/models/role.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final List<Role> roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      roles: (json["roles"] as List<dynamic>).map((e) => Role.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": password,
      "roles": roles.map((e) => e.toJson()).toSet(),
    };
  }
}
