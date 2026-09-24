import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static const String loginEndPoint = '/auth/login';

  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String register = '/api/drivers/applications';
  // '/api/v1/auth/signup';

  // no countries endpoint exists on the gateway yet — this one 404s
  static const String countries = '/api/v1/meta/countries';
  static const String vehicleTypes = '/api/v1/meta/vehicle-types';

  static const String availableOrders = '/order/drivers/available-orders';
  static const String acceptOrder = '/order/drivers/me/orders/{orderId}/accept';
}
