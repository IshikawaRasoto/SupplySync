import '../../../../../core/common/entities/user.dart';
import '../../../../../core/constants/constants.dart';

class TargetUserModel extends User {
  TargetUserModel({
    required super.userName,
    required super.name,
    required super.email,
    required super.roles,
  }) : super(jwtToken: '', password: '');

  factory TargetUserModel.fromJson(Map<String, dynamic> json) {
    // final rolesJson = (json['roles'] as List<dynamic>).cast<String>();
    // rolesJson.removeWhere(
    //     (element) => !UserRoles.values.any((e) => e.name == element));
    final List<UserRoles> rolesJson = [];
    if (UserRoles.values
        .any((element) => element.name == json['roles'].toString())) {
      rolesJson.add(UserRoles.values
          .firstWhere((element) => element.name == json['roles'].toString()));
    }

    return TargetUserModel(
      userName: json['username'].toString(),
      email: json['email'].toString(),
      name: json['name'].toString(),
      roles: rolesJson,
      // roles: rolesJson
      //     .map((e) =>
      //         UserRoles.values.firstWhere((element) => element.name == e))
      //     .toList(),
    );
  }
}
