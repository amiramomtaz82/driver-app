import 'package:equatable/equatable.dart';

class UpdateVehicleParams extends Equatable {
  final String vehicleType;
  final String vehicleNumber;
  final String? licenseFilePath;

  const UpdateVehicleParams({
    required this.vehicleType,
    required this.vehicleNumber,
    this.licenseFilePath,
  });

  @override
  List<Object?> get props => [vehicleType, vehicleNumber, licenseFilePath];
}