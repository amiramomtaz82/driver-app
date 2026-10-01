import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static String get baseUrl => dotenv.env['BASE_URL']!;
  static const String register = '/api/drivers/applications';
  static const String countries = '/api/v1/countries';
  static const String vehicleTypes = '/api/v1/vehicle-types';

}