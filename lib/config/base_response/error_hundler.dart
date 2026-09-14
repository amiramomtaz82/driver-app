import 'package:dio/dio.dart';
import 'package:driver_app/generated/locale_keys.g.dart';

import 'backend_messages_extractor.dart';
import 'dio_exception_mapper.dart';

class ErrorHandler {
  ErrorHandler._();

  static String extractErrorMessage(Object error) {
    if (error is DioException) {
      final backendMessage = BackendMessageExtractor.extract(error);
      if (backendMessage != null) return backendMessage;

      return DioExceptionMapper.toMessage(error);
    } else {
      return LocaleKeys.errors_something_went_wrong;
    }
  }

  static int? extractStatusCode(Object error) {
    if (error is DioException) return error.response?.statusCode;
    return null;
  }
}
