import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable()
class RegisterResponseDto {
  final String? message;
  final String? token;
  final bool? success;

  const RegisterResponseDto({this.message, this.token, this.success});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
}