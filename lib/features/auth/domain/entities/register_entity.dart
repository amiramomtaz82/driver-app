import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String gender;
  final String vehicleType;
  final String vehicleNumber;
  final String nationalId;
  final String? vehicleLicense;
  final String? idImage;

  const RegisterEntity({
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

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        password,
        gender,
        vehicleType,
        vehicleNumber,
        nationalId,
        vehicleLicense,
        idImage,
      ];
}
