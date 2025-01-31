class TargetUserUpdateModel {
  String? targetUserName;
  String? newName;
  String? newEmail;
  String? password;
  String? newPassword;

  TargetUserUpdateModel({
    this.targetUserName,
    this.newName,
    this.newEmail,
    this.password,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': targetUserName,
      'name': newName,
      'email': newEmail,
      'password': password,
      'newPassword': newPassword,
    };
  }
}
