import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/constants/endpoints.dart';
import '../network/auth_interceptor.dart';
import '../network/local_interceptor.dart';

@module
abstract class DioModule {
  @singleton
  Dio dio(AuthInterceptor authInterceptor, LocaleInterceptor localeInterceptor) {
    final dioInstance = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dioInstance.interceptors.add(authInterceptor);
    dioInstance.interceptors.add(localeInterceptor);
    dioInstance.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
    return dioInstance;
  }
}
