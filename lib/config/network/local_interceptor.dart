import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../local/local_service.dart';
@injectable
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor(this._localeService);
  final LocaleService _localeService;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _localeService.languageCode;
    handler.next(options);
  }
}
