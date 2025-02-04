import '../common/entities/user.dart';
import '../constants/constants.dart';

List<AppServices> getUserServices(User user) =>
    user.roles.map((role) => role.permissions).expand((e) => e).toList();

bool checkUserServicePermission(User user, AppServices permission) =>
    getUserServices(user).contains(permission);
