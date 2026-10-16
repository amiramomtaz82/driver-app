import 'package:equatable/equatable.dart';

class UpdateUserProfileParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String? photoFilePath;

  const UpdateUserProfileParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    this.photoFilePath,
  });

  @override
  List<Object?> get props => [fullName, email, phone, gender, photoFilePath];
}