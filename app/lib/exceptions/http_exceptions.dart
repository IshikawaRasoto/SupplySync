import '../constants/exceptions_constants.dart';

class HttpExceptionCustom implements Exception {
  late String? _statusCode;
  late String? _message;

  HttpExceptionCustom(String? statusCode,
      {String message = HttpExceptionConstants.generalError}) {
    _statusCode = (statusCode != null) ? statusCode : '';
    _message = message;
    // Use the message parameter
  }

  @override
  String toString() => 'Erro $_statusCode. $_message';
}
