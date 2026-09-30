import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/register_response_entity.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  final String? message;
  final String? token;
  final bool? success;

  const RegisterResponseDto({this.message, this.token, this.success});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);

  /// Mapper: Converts Data DTO to Domain Entity
  RegisterEntityResponse toEntity() {
    return RegisterEntityResponse(
      message: message,
      token: token,
      success: success,
    );
  }
}