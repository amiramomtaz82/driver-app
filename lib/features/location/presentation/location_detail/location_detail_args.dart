import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';

class LocationDetailArgs {
  const LocationDetailArgs({
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
  });
  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;
}
