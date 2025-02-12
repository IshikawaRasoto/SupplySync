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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // final rolesJson = (json['roles'] as List<dynamic>).cast<String>();
    // rolesJson.removeWhere(
    //     (element) => !UserRoles.values.any((e) => e.name == element));
    final List<UserRoles> rolesJson = [
      UserRoles.values
          .firstWhere((element) => element.name == json['roles'].toString())
    ];
    return User(
        userName: json['username'].toString(),
        email: json['email'].toString(),
        password: json['password'].toString(),
        name: json['name'].toString(),
        jwtToken: json['jwt_token'].toString(),
        roles: rolesJson
        // roles: rolesJson
        //     .map((e) =>
        //         UserRoles.values.firstWhere((element) => element.name == e))
        //     .toList(),
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'password': password,
      'name': name,
      'jwt_token': jwtToken,
      'roles': roles.map((e) => e.name).toList()
    };
  }
}
