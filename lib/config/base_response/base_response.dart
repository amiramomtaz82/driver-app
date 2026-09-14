

import '../../generated/locale_keys.g.dart';
import 'error_hundler.dart';

sealed class BaseResponse<T> {
  const BaseResponse();
}

class SuccessResponse<T> extends BaseResponse<T> {
  final T data;

  const SuccessResponse(this.data);
}

class ErrorResponse<T> extends BaseResponse<T> {
  final Object? error;
  final String errMessage;
  final int? statusCode;

  ErrorResponse({this.error, String? errMessage})
      : errMessage = error != null
      ? ErrorHandler.extractErrorMessage(error)
      : (errMessage ?? LocaleKeys.errors_something_went_wrong),
        statusCode = error != null ? ErrorHandler.extractStatusCode(error) : null;

  bool get isUnauthorized => statusCode == 401;
}
