import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String gender;
  final String vehicleType;
  final String vehicleNumber;
  final String? vehicleLicense;
  final String nationalId;
  final String? idImage;

  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.vehicleType,
    required this.vehicleNumber,
    this.vehicleLicense,
    required this.nationalId,
    this.idImage,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}