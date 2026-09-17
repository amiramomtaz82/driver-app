import 'base_response.dart';

/// Wraps an API call and returns a [BaseResponse] (either [SuccessResponse] or [ErrorResponse]).
Future<BaseResponse<T>> safeCall<T>(Future<T> Function() apiCall) async {
  try {
    final response = await apiCall();
    return SuccessResponse<T>(response);
  } catch (error) {
    return ErrorResponse<T>(error: error);
  }
}