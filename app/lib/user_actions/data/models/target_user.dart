import '../../../core/common/entities/user.dart';
import '../../../core/constants/constants.dart';

class TargetUser extends User {
  TargetUser({
    required super.userName,
    required super.name,
    required super.email,
    required super.roles,
  }) : super(jwtToken: '', password: '');

  factory TargetUser.fromJson(Map<String, dynamic> json) {
    final rolesJson = (json['roles'] as List<dynamic>).cast<String>();
    rolesJson.removeWhere(
        (element) => !UserRoles.values.any((e) => e.name == element));
    rolesJson.contains(UserRoles.user.name)
        ? null
        : rolesJson.add(UserRoles.user.name);
    return TargetUser(
      userName: json['username'],
      email: json['email'],
      name: json['name'],
      roles: rolesJson
          .map((e) =>
              UserRoles.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }
}
