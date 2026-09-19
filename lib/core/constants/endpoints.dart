import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static const String loginEndPoint = '';
  static const String register = '';
  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';}