import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reset_token_entity.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable(createToJson: false)
class VerifyOtpResponseModel {
  final VerifyOtpResponseData value;

  const VerifyOtpResponseModel({required this.value});

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class VerifyOtpResponseData {
  final String resetToken;

  @JsonKey(fromJson: _parseAsUtc)
  final DateTime expirationDate;

  const VerifyOtpResponseData({
    required this.resetToken,
    required this.expirationDate,
  });

  factory VerifyOtpResponseData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseDataFromJson(json);

  ResetToken toEntity() => ResetToken(token: resetToken, expiresAt: expirationDate);
}

DateTime _parseAsUtc(String value) {
  final date = DateTime.parse(value);
  return date.isUtc ? date : DateTime.parse('${value}Z');
}
