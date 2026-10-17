import 'package:equatable/equatable.dart';

class DriverVehicleEntity extends Equatable {
  final String vehicleType;
  final String vehicleNumber;
  final String? licensePhotoUrl;

  const DriverVehicleEntity({
    required this.vehicleType,
    required this.vehicleNumber,
    this.licensePhotoUrl,
  });

  @override
  List<Object?> get props => [vehicleType, vehicleNumber, licensePhotoUrl];
}