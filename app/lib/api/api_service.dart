import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../exceptions/http_exceptions.dart';
import '../models/user.dart';

class ApiService {
  static final _logger = Logger();
  static final ApiService _instance = ApiService._();

  ApiService._();
  factory ApiService() {
    return _instance;
  }

  Future<Map<String, dynamic>> login(User user) async {
    try {
      final response = await postData(user, ApiEndpoints.login, {
        'username': user.userName,
        'password': user.password,
      }, header: {
        'Cache-Control': 'no-cache',
      });
      if (response.containsKey('jwt_token')) {
        _logger.i('User logged in successfully');
        return response;
      } else {
        _logger.e('Failed to log in. Status code: ${response['statusCode']}');
        throw HttpExceptionCustom(response['statusCode'].toString());
      }
    } catch (e) {
      _logger.e('An error occurred while logging in: $e');
      rethrow;
    }
  }

  Future<bool> registerNewUser(User user) async {
    try {
      final response = await postData(user, ApiEndpoints.user, {
        'username': user.userName,
        'password': user.password,
        'email': user.email,
        'name': user.fullName,
        'roles': jsonEncode(user.roles.map((e) => e.toString()).toList()),
      });
      if (response.containsKey('jwt_token')) {
        _logger.i('User registered successfully');
        return true;
      } else {
        _logger.e(
            'Failed to register user. Status code: ${response['statusCode']}');
        throw HttpExceptionCustom(response['statusCode'].toString());
      }
    } catch (e) {
      _logger.e('An error occurred while registering user: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchData(User user, ApiEndpoints requestType,
      {Map<String, String>? header, Map<String, String>? pathParams}) async {
    final uri = Uri.parse(
        '$ApiConstants.baseUrl/${_buildPath(requestType, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer ${user.jwtToken}',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response = await http.delete(uri, headers: headers);
      _statusHandler(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postData(
      User user, ApiEndpoints requestType, Map<String, dynamic> data,
      {Map<String, String>? header, Map<String, String>? pathParams}) async {
    final uri = Uri.parse(
        '$ApiConstants.baseUrl/${_buildPath(requestType, pathParams)}');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Autorization': 'Bearer ${user.jwtToken}',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response = await http.delete(uri, headers: headers);
      _statusHandler(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      rethrow;
    }
  }

  Future<bool> updateData(
      User user, ApiEndpoints requestType, Map<String, dynamic> data,
      {Map<String, String>? header, Map<String, String>? pathParams}) async {
    final uri = Uri.parse(
        '$ApiConstants.baseUrl/${_buildPath(requestType, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer ${user.jwtToken}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response = await http.delete(uri, headers: headers);
      _statusHandler(response);
      return true;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      rethrow;
    }
  }

  Future<void> deleteData(
    User user,
    String id,
    ApiEndpoints requestType, {
    Map<String, String>? header,
    Map<String, String>? pathParams,
  }) async {
    final uri = Uri.parse(
        '$ApiConstants.baseUrl/${_buildPath(requestType, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer ${user.jwtToken}',
    };
    try {
      final response = await http.delete(uri, headers: headers);
      _statusHandler(response);
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      rethrow;
    }
  }

  void _statusHandler(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      _logger.i('Request successful');
    } else {
      final errorData = jsonDecode(response.body);
      final statusCode = errorData['error']['code'] != null
          ? '${response.statusCode}: ${errorData['error']['code']}'
          : response.statusCode.toString();
      final errorMessage = errorData['error']['message'] ?? 'Ocorreu um erro';
      final errorDetails = errorData['error']['details'] ?? '';
      _logger.e('Request failed. Status code: $statusCode\n'
          'Message: $errorMessage\n'
          'Details: $errorDetails');
      throw HttpExceptionCustom(statusCode,
          message: '$errorMessage. $errorDetails');
    }
  }

  String _buildPath(ApiEndpoints requestType, Map<String, String>? pathParams) {
    String path = requestType.path;
    if (pathParams != null) {
      pathParams.forEach((key, value) {
        path = path.replaceAll('{$key}', value);
      });
    }
    return path;
  }
}
