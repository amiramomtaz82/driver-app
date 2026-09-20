import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'accessToken')
  final String token;

  final String refreshToken;
  final int expiresIn;
  final String? driverStatus;
  final UserModel user;

  const LoginResponseModel({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    this.driverStatus,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
