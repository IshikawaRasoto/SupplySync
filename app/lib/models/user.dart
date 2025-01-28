import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../constants/api_constants.dart';
import '../constants/constants.dart';

class User with ChangeNotifier {
  final ApiService apiService = ApiService();
  String _userName = '';
  String _email = '';
  String _fullName = '';
  String _password = '';
  String _jwtToken = '';
  List<UserRoles> _roles = [];

  DateTime? _lastLogin;

  String get userName => _userName;
  String get fullName => _fullName;
  String get email => _email;
  String get password => _password;
  String get jwtToken => _jwtToken;
  List<UserRoles> get roles => _roles;

  void clear() {
    _email = '';
    _userName = '';
    _password = '';
    _jwtToken = '';
    notifyListeners();
  }

  User({
    String email = '',
    String password = '',
    String jwtToken = '',
    String userName = '',
    String fullName = '',
  })  : _email = email,
        _userName = userName,
        _fullName = fullName,
        _password = password,
        _jwtToken = jwtToken;

  Future<bool> fakeLogin(String userName) async {
    _userName = userName.isEmpty ? 'HBWho' : userName;
    _email = 'alexei@gmail.com';
    _password = 'teste123';
    _fullName = 'Alexei Lara';
    _jwtToken = 'lkashjdlashdslahdapsidjpaisfjasiopdjfilosafhias';
    _roles = [UserRoles.admin];
    _lastLogin = DateTime.now();
    notifyListeners();
    return true;
  }

  Future<bool> register({List<UserRoles>? roles}) async {
    if (userName.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        fullName.isEmpty) return false;
    _roles = roles ?? [UserRoles.user];
    return await apiService.registerNewUser(this);
  }

  Future<bool> login(String userName, String password) async {
    if (userName.isEmpty || password.isEmpty) return false;
    try {
      _userName = userName;
      _password = password;
      final response = await apiService.login(this);
      _email = response[ApiBodyParts.email.name];
      _jwtToken = response[ApiBodyParts.jwt_token.name];
      _fullName = response[ApiBodyParts.name.name];
      _roles = jsonDecode(response[ApiBodyParts.roles.name])
          .map((role) => UserRoles.values.firstWhere(
              (element) => element.toString() == role,
              orElse: () => UserRoles.none))
          .toList();
      _lastLogin = DateTime.now();
      notifyListeners();
      return _jwtToken.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile(
      {String? newName,
      String? newEmail,
      String? oldPassword,
      String? newPassword,
      List<UserRoles>? newRoles}) async {
    assert((oldPassword == null && newPassword == null) ||
        (oldPassword != null && newPassword != null));
    try {
      Map<String, String> changes = {
        ApiBodyParts.username.name: _userName,
        if (newName != null) ApiBodyParts.name.name: newName,
        if (newEmail != null) ApiBodyParts.email.name: newEmail,
        if (oldPassword != null) ApiBodyParts.password.name: oldPassword,
        if (newPassword != null) ApiBodyParts.new_password.name: newPassword,
        if (newRoles != null)
          ApiBodyParts.roles.name:
              newRoles.map((e) => e.toString()).toList().toString(),
      };
      if (await apiService.updateData(this, ApiEndpoints.user, changes)) {
        if (newName != null) _fullName = newName;
        if (newEmail != null) _email = newEmail;
        if (newPassword != null) _password = newPassword;
        if (newRoles != null) _roles = newRoles;
        notifyListeners();
        return true;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    if (_jwtToken.isNotEmpty &&
        _lastLogin != null &&
        DateTime.now().difference(_lastLogin!) <= Duration(minutes: 30)) {
      return true;
    }
    try {
      return await login(_email, _password);
    } catch (e) {
      return false;
    }
  }
}
