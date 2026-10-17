import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/driver_vehicle_entity.dart';

part 'driver_vehicle_dto.g.dart';

@JsonSerializable()
class DriverVehicleDto {
  final String? vehicleType;
  final String? vehicleNumber;
  final String? licensePhotoUrl;

  const DriverVehicleDto({
    this.vehicleType,
    this.vehicleNumber,
    this.licensePhotoUrl,
  });

  factory DriverVehicleDto.fromJson(Map<String, dynamic> json) =>
      _$DriverVehicleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverVehicleDtoToJson(this);

  DriverVehicleEntity toEntity() {
    return DriverVehicleEntity(
      vehicleType: vehicleType ?? '',
      vehicleNumber: vehicleNumber ?? '',
      licensePhotoUrl: licensePhotoUrl,
    );
  }
}