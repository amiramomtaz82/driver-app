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

  factory VehicleTypeDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeDtoToJson(this);

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