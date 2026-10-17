import 'package:equatable/equatable.dart';
import 'driver_vehicle_entity.dart';

class DriverProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String? photoUrl;
  final DriverVehicleEntity? vehicle;

  const DriverProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    this.photoUrl,
    this.vehicle,
  });

  String get firstName {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  String get lastName {
    final parts = fullName.trim().split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  DriverProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? gender,
    String? photoUrl,
    DriverVehicleEntity? vehicle,
  }) {
    return DriverProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    gender,
    photoUrl,
    vehicle,
  ];
}