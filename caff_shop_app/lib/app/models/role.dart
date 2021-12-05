import 'package:caff_shop_app/app/models/role_type.dart';

class Role {
  final String id;
  final RoleType type;

  Role({
    required this.id,
    required this.type,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["id"],
      type: (json["name"] as String).toRoleType()!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": type.value,
    };
  }
}
