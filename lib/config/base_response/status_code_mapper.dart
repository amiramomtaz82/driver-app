import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';


class StatusCodeMapper {
  StatusCodeMapper._();

  static const Map<int, String> _messages = {
    400: LocaleKeys.errors_request_cancelled,
    401: LocaleKeys.errors_session_expired,
    403: LocaleKeys.errors_no_permission,
    404: LocaleKeys.errors_data_not_found,
    409: LocaleKeys.errors_conflict_occurred,
    422: LocaleKeys.errors_invalid_fields,
    500: LocaleKeys.errors_internal_server_error,
    502: LocaleKeys.errors_internal_server_error,
    503: LocaleKeys.errors_internal_server_error,
  };

  static String toMessage(int? statusCode) {
    final key = _messages[statusCode] ?? LocaleKeys.errors_something_went_wrong;
    return tr(key);
  }
}