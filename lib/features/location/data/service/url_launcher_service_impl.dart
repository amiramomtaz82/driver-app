import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'url_launcher_service.dart';

@Injectable(as: UrlLauncherService)
class UrlLauncherServiceImpl implements UrlLauncherService {
  @override
  Future<bool> launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }

  @override
  Future<bool> launchSms(String phone) async {
    final uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }
}
