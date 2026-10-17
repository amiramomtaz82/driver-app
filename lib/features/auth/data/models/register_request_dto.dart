import 'package:dio/dio.dart';

import '../../domain/entities/register_form.dart';


class RegisterRequestDto {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String gender;
  final String vehicleType;
  final String vehicleNumber;
  final String nationalId;
  final MultipartFile? vehicleLicense;
  final MultipartFile? idImage;

  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.nationalId,
    this.vehicleLicense,
    this.idImage,
  });

  /// Mapper: Converts Domain RegisterRequestParams (String paths) to Data DTO (MultipartFile)
  static Future<RegisterRequestDto> fromParams(RegisterForm  params) async {
    return RegisterRequestDto(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      gender: params.gender,
      vehicleType: params.vehicleType,
      vehicleNumber: params.vehicleNumber,
      nationalId: params.nationalId,
      vehicleLicense: (params.vehicleLicense != null && params.vehicleLicense!.isNotEmpty)
          ? await MultipartFile.fromFile(params.vehicleLicense!)
          : null,
      idImage: (params.idImage != null && params.idImage!.isNotEmpty)
          ? await MultipartFile.fromFile(params.idImage!)
          : null,
    );
  }

  /// Converts fields and MultipartFiles into a map for @PartMap()
  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'password': password,
    'gender': gender,
    'vehicleType': vehicleType,
    'vehicleNumber': vehicleNumber,
    'nationalId': nationalId,
    if (vehicleLicense != null) 'vehicleLicense': vehicleLicense,
    if (idImage != null) 'idImage': idImage,
  };
}