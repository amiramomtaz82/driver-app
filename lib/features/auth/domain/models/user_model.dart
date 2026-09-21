import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final bool isActive;
  final String? driverStatus;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
    this.driverStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
