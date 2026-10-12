import 'package:dio/dio.dart';
import 'package:driver_app/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'location_client.g.dart';

@singleton
@RestApi()
abstract class LocationApiClient {
  @factoryMethod
  factory LocationApiClient(Dio dio) = _LocationApiClient;

  @POST(Endpoints.driverLocation)
  Future<HttpResponse<dynamic>> getDriverLocation();

  @POST(Endpoints.driverLocation)
  Future<void> reportDriverLocation(@Body() Map<String, dynamic> body);
}
