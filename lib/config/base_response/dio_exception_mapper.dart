import 'package:dio/dio.dart';
import 'package:driver_app/config/base_response/status_code_mapper.dart';

import '../../generated/locale_keys.g.dart';


class DioExceptionMapper {
  DioExceptionMapper._();

  static String toMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return LocaleKeys.errors_connection_timeout;
      case DioExceptionType.connectionError:
        return LocaleKeys.errors_no_internet_connection;
      case DioExceptionType.badCertificate:
        return LocaleKeys.errors_invalid_certificate;
      case DioExceptionType.cancel:
        return LocaleKeys.errors_request_cancelled;
      case DioExceptionType.badResponse:
        return StatusCodeMapper.toMessage(error.response?.statusCode);
      default:
        return LocaleKeys.errors_check_your_connection;
    }
  }
}
