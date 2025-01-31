import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/http_exceptions.dart';

class ApiService {
  static final _logger = Logger();
  static final ApiService _instance = ApiService._();

  ApiService._();
  factory ApiService() {
    return _instance;
  }

  Future<Map<String, dynamic>> fetchData(
      {required ApiEndpoints endPoint,
      required String jwtToken,
      Map<String, String>? header,
      Map<String, String>? pathParams}) async {
    final uri =
        Uri.parse('$ApiConstants.baseUrl/${_buildPath(endPoint, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer $jwtToken',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response = await http.get(uri, headers: headers);
      _statusHandler(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      throw HttpExceptionCustom(e.toString());
    }
  }

  Future<Map<String, dynamic>> postData(
      {required ApiEndpoints endPoint,
      String? jwtToken,
      Map<String, dynamic>? body,
      Map<String, String>? header,
      Map<String, String>? pathParams}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/${_buildPath(endPoint, pathParams)}');
    final Map<String, String> headers = {
      if (jwtToken != null) 'Autorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      _statusHandler(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      throw HttpExceptionCustom(e.toString());
    }
  }

  Future<bool> updateData(
      {required ApiEndpoints endPoint,
      required String jwtToken,
      required Map<String, dynamic> body,
      Map<String, String>? header,
      Map<String, String>? pathParams}) async {
    final uri =
        Uri.parse('$ApiConstants.baseUrl/${_buildPath(endPoint, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response =
          await http.put(uri, headers: headers, body: jsonEncode(body));
      _statusHandler(response);
      return true;
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data: $e');
      throw HttpExceptionCustom(e.toString());
    }
  }

  Future<void> deleteData(
      {required ApiEndpoints endPoint,
      required String jwtToken,
      required String id,
      Map<String, String>? header,
      Map<String, String>? pathParams}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/${_buildPath(endPoint, pathParams)}');
    final Map<String, String> headers = {
      'Autorization': 'Bearer $jwtToken',
      'id': id,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?header,
    };
    try {
      final response = await http.delete(uri, headers: headers);
      _statusHandler(response);
    } on HttpExceptionCustom {
      rethrow;
    } catch (e) {
      _logger.e('An error occurred while deleting data on server: $e');
      throw HttpExceptionCustom(e.toString());
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
