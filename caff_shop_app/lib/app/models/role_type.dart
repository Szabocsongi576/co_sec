enum RoleType {
  ROLE_USER,
  ROLE_ADMIN,
}

extension RoleToStringExtension on RoleType {
  String get value {
    switch(this) {
      case RoleType.ROLE_USER:
        return 'ROLE_USER';
      case RoleType.ROLE_ADMIN:
        return 'ROLE_ADMIN';
    }
  }
}

extension StringToRoleExtension on String {
  RoleType? toRoleType() {
    switch(this) {
      case 'ROLE_USER':
        return RoleType.ROLE_USER;
      case 'ROLE_ADMIN':
        return RoleType.ROLE_ADMIN;
      default:
        return null;
    }
  }
}