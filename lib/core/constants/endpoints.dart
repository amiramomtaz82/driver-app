import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static String get baseUrl => dotenv.env['BASE_URL']!;

  static const String loginEndPoint = '/auth/login';
  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  static const String register = '/api/drivers/applications';
  static const String countries = '/api/v1/countries';
  static const String vehicleTypes = '/api/v1/vehicle-types';

  static const String availableOrders = '/order/drivers/available-orders';
  static const String acceptOrder = '/order/drivers/me/orders/{orderId}/accept';
  static const String activeOrder = '/order/drivers/me/active-order';
  static const String driverOrderDetails = '/order/drivers/me/orders/{orderId}';
  static const String updateOrderStatus = '/order/orders/{orderId}/status';

  // Profile Endpoints
  static const String getUserProfile = '/api/users/GetProfile';
  static const String updateUserProfile = '/api/users/UpdateProfile';
  static const String changePassword = '/auth/change-password';
  // Vehicle Endpoints
  static const String getDriverVehicle = '/api/v1/drivers/me/vehicle';
  static const String updateDriverVehicle = '/api/v1/drivers/me/vehicle';

  static const String logout = '/auth/logout';
  static const String driverLocation = '/order/drivers/me/location';
}
