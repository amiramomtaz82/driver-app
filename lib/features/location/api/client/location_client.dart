import 'package:dio/dio.dart';
import 'package:driver_app/core/constants/endpoints.dart';
import 'package:driver_app/features/location/data/models/driver_location_request_dto.dart';
import 'package:driver_app/features/location/data/models/driver_location_response_dto.dart';
import 'package:driver_app/features/location/data/models/osrm_route_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'location_client.g.dart';

@singleton
@RestApi()
abstract class LocationApiClient {
  @factoryMethod
  factory LocationApiClient(Dio dio) = _LocationApiClient;

  @POST(Endpoints.driverLocation)
  Future<DriverLocationResponseDto> getDriverLocation();

  @POST(Endpoints.driverLocation)
  Future<void> reportDriverLocation(@Body() DriverLocationRequestDto body);

  @GET('https://router.project-osrm.org/route/v1/driving/{coordinates}')
  Future<OsrmRouteResponseDto> getRoute(
    @Path('coordinates') String coordinates, {
    @Query('overview') String overview = 'full',
    @Query('geometries') String geometries = 'geojson',
  });
}
