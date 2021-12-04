import 'package:caff_shop_app/app/models/role_type.dart';

class LoginResponse {
  final String id;
  final String username;
  final String email;
  final List<RoleType> roles;
  final String accessToken;
  final String tokenType;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.accessToken,
    required this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      roles: (json["roles"] as List<dynamic>).map((e) => e.toString().toRoleType()!).toList(),
      accessToken: json["accessToken"],
      tokenType: json["tokenType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "roles": roles.map((e) => e.value).toList(),
      "accessToken": accessToken,
      "tokenType": tokenType,
    };
  }
}
