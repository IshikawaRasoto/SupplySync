import '../constants/exceptions_constants.dart';

class ConversionException implements Exception {
  final String message;
  const ConversionException(
      [this.message = ServerExceptionConstants.generalError]);
}
