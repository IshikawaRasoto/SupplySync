import 'package:permission_handler/permission_handler.dart';

import '../constants/constants.dart';
import '../models/user.dart';

class PermissionHelper {
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  static bool checkUserRolePermission(User user, UserPermissions permission) {
    if (user.roles.isEmpty) return false;
    if (user.roles.contains(UserRoles.admin)) return true;
    return RolesPermissions.permissions[user.roles.first]
            ?.contains(permission) ??
        false;
  }
}
