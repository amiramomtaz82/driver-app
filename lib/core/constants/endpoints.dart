import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static const String loginEndPoint = '/auth/login';

}


  static const String countries = '/api/v1/meta/countries';
  static const String vehicleTypes = '/api/v1/meta/vehicle-types';

}