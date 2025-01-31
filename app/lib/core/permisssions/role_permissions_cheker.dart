import '../common/entities/user.dart';
import '../constants/constants.dart';

bool checkUserRolePermission(User user, UserPermissions permission) {
  if (user.roles.isEmpty) return false;
  if (user.roles.contains(UserRoles.admin)) return true;
  return RolesPermissions.permissions[user.roles.first]?.contains(permission) ??
      false;
}

List<UserPermissions> getUserPermissions(User user) {
  if (user.roles.isEmpty) return [];
  if (user.roles.contains(UserRoles.admin)) {
    return UserPermissions.values;
  }
  return RolesPermissions.permissions[user.roles.first] ?? [];
}
