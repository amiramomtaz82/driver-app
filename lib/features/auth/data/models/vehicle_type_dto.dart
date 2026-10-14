import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/vehicle_type_entity.dart';

part 'vehicle_type_dto.g.dart';

@JsonSerializable()
class VehicleTypeDto {
  @JsonKey(name: '_id') // or 'id'
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'icon')
  final String? icon;

  const VehicleTypeDto({
    this.id,
    this.name,
    this.icon,
  });

  factory VehicleTypeDto.fromJson(Map<String, dynamic> json) {
    return VehicleTypeDto(
      id: (json['id'] ?? json['_id'])?.toString(), // 👈 Converts 1 -> "1" safely
      name: json['name'] as String?,
      icon: json['icon'] as String?,
    );
  }

  /// Mapper: Converts Data DTO to Domain Entity
  VehicleType toEntity() {
    return VehicleType(
      id: id ?? '',
      name: name ?? '',
      icon: icon,
    );
  }

  // ==========================================
  // DUMMY DATA (For when useDummyData = true)
  // ==========================================
  static const List<VehicleTypeDto> dummyList = [
    VehicleTypeDto(id: 'car', name: 'Car'),
    VehicleTypeDto(id: 'motorcycle', name: 'Motorcycle'),
    VehicleTypeDto(id: 'scooter', name: 'Scooter'),
    VehicleTypeDto(id: 'van', name: 'Van'),
  ];
}

class VehicleTypesResponseDto {
  final bool? success;
  final String? message;
  final List<VehicleTypeDto>? data;

  const VehicleTypesResponseDto({
    this.success,
    this.message,
    this.data,
  });

  factory VehicleTypesResponseDto.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    return VehicleTypesResponseDto(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: rawList
          .map((item) => VehicleTypeDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}