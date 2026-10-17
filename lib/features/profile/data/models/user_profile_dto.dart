import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/driver_profile_entity.dart';
import 'driver_vehicle_dto.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable()
class UserProfileDto {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? photoUrl;
  final DriverVehicleDto? vehicle;

  const UserProfileDto({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.photoUrl,
    this.vehicle,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);

  DriverProfileEntity toEntity() {
    return DriverProfileEntity(
      id: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      phone: phone ?? '',
      gender: gender ?? '',
      photoUrl: photoUrl,
      vehicle: vehicle?.toEntity(),
    );
  }
}