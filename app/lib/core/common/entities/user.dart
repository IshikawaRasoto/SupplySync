import '../../constants/constants.dart';

class User {
  String userName;
  String email;
  String password;
  String name;
  String jwtToken;

  List<UserRoles> roles;

  User({
    required this.userName,
    required this.email,
    required this.password,
    required this.name,
    required this.jwtToken,
    required this.roles,
  }) {
    if (!roles.contains(UserRoles.user)) {
      roles.add(UserRoles.user);
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final rolesJson = (json['roles'] as List<dynamic>).cast<String>();
    rolesJson.removeWhere(
        (element) => !UserRoles.values.any((e) => e.name == element));
    rolesJson.contains(UserRoles.user.name)
        ? null
        : rolesJson.add(UserRoles.user.name);
    return User(
      userName: json['username'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      jwtToken: json['jwtToken'],
      roles: rolesJson
          .map((e) =>
              UserRoles.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'password': password,
      'name': name,
      'jwtToken': jwtToken,
      'roles': roles.map((e) => e.name).toList(),
    };
  }
}
