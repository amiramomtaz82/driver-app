import 'package:dio/dio.dart';

class BackendMessageExtractor {
  BackendMessageExtractor._();

  static String? extract(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message =
          data['messageLocalized'] ??
              data['message'] ??
              data['error'] ??
              data['msg'];
      if (message is String && message.trim().isNotEmpty) return message;
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }
}
