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
      if (targetUserName != null) 'username': targetUserName,
      if (newName != null) 'name': newName,
      if (newEmail != null) 'email': newEmail,
      if (password != null) 'password': password,
      if (newPassword != null) 'new_password': newPassword,
    };
  }
}
