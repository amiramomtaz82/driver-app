import 'package:dio/dio.dart';
import '../../domain/entities/update_vehicle_params.dart';


class UpdateVehicleRequestDto {
  final String vehicleType;
  final String vehicleNumber;
  final MultipartFile? vehicleLicenseFile;

  const UpdateVehicleRequestDto({
    required this.vehicleType,
    required this.vehicleNumber,
    this.vehicleLicenseFile,
  });

  /// Factory Mapper: Converts Domain Params to Data Multipart DTO
  static Future<UpdateVehicleRequestDto> fromParams(
      UpdateVehicleParams params,
      ) async {
    MultipartFile? file;
    if (params.licenseFilePath != null &&
        params.licenseFilePath!.isNotEmpty &&
        !params.licenseFilePath!.startsWith('http://') &&
        !params.licenseFilePath!.startsWith('https://')) {
      file = await MultipartFile.fromFile(params.licenseFilePath!);
    }

    return UpdateVehicleRequestDto(
      vehicleType: params.vehicleType,
      vehicleNumber: params.vehicleNumber,
      vehicleLicenseFile: file,
    );
  }

  /// Converts fields into a multipart map for @PartMap()
  Map<String, dynamic> toMap() => {
    'VehicleType': vehicleType,
    'VehicleNumber': vehicleNumber,
    if (vehicleLicenseFile != null)
      'VehicleLicenceFile': vehicleLicenseFile,
  };
}