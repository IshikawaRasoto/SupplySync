import '../constants/exceptions_constants.dart';

class HttpExceptionCustom implements Exception {
  late String? statusCode;
  late String? message;

  HttpExceptionCustom(String? statusCode,
      {String message = HttpExceptionConstants.generalError}) {
    statusCode = (statusCode != null) ? statusCode : '';
    message = message;
    // Use the message parameter
  }

  @override
  String toString() => 'Erro $statusCode. $message';
}
