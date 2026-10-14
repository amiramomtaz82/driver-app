abstract interface class UrlLauncherService {
  Future<bool> launchPhone(String phone);
  Future<bool> launchSms(String phone);
}
