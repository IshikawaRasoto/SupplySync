class NewUserModel {
  final String userName;
  final String name;
  final String email;
  final String password;
  final String roles;
  NewUserModel({
    required this.userName,
    required this.name,
    required this.email,
    required this.password,
    required List<String> roles,
  }) : roles = roles.first;

  factory NewUserModel.fromJson(Map<String, dynamic> json) {
    return NewUserModel(
      name: json['name'],
      userName: json['userName'],
      email: json['email'],
      password: json['password'],
      roles: json['roles'],
    );
  }

  Map<String, String> toJson() {
    return {
      'username': userName,
      'name': name,
      'password': password,
      'email': email,
      'roles': roles
    };
  }
}
