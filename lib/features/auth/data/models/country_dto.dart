import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_dto.g.dart';

@JsonSerializable()
class CountryDto {
  @JsonKey(name: '_id') // or 'id' depending on your backend
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'flag')
  final String? flag;

  @JsonKey(name: 'code')
  final String? code; // e.g. '+20' or 'EG'

  const CountryDto({
    this.id,
    this.name,
    this.flag,
    this.code,
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) =>
      _$CountryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDtoToJson(this);

  /// Mapper: Converts Data DTO to Domain Entity
  Country toEntity() {
    return Country(
      id: id ?? '',
      name: name ?? '',
      flag: flag ?? '🇪🇬',
      code: code ?? '+20',
    );
  }

  // ==========================================
  // DUMMY DATA (For when useDummyData = true)
  // ==========================================
  static const List<CountryDto> dummyList = [
    CountryDto(
      id: 'eg',
      name: 'Egypt',
      flag: '🇪🇬',
      code: '+20',
    ),
    CountryDto(
      id: 'sa',
      name: 'Saudi Arabia',
      flag: '🇸🇦',
      code: '+966',
    ),
    CountryDto(
      id: 'ae',
      name: 'UAE',
      flag: '🇦🇪',
      code: '+971',
    ),
  ];
}