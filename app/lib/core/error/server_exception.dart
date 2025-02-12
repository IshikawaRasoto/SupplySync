import '../constants/exceptions_constants.dart';

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = ServerExceptionConstants.generalError]);
}
