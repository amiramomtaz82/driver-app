import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response_model.g.dart';

@JsonSerializable(createToJson: false)
class VerifyOtpResponseModel {
  final ResetTokenModel value;

  const VerifyOtpResponseModel({required this.value});

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ResetTokenModel extends Equatable {
  final String resetToken;

  @JsonKey(name: 'expirationDate', fromJson: _parseUtc)
  final DateTime expiresAt;

  const ResetTokenModel({required this.resetToken, required this.expiresAt});

  factory ResetTokenModel.fromJson(Map<String, dynamic> json) =>
      _$ResetTokenModelFromJson(json);

  bool isExpired(DateTime now) => now.isAfter(expiresAt);

  @override
  List<Object?> get props => [resetToken, expiresAt];
}

/// The backend sends UTC dates, sometimes without the `Z` suffix, which
/// `DateTime.parse` would otherwise read as local time.
DateTime _parseUtc(String value) {
  final date = DateTime.parse(value);
  return date.isUtc ? date : DateTime.parse('${value}Z');
}
