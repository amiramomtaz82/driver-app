import 'package:dio/dio.dart';

import '../../domain/entities/update_user_profile_params.dart';

class UpdateUserProfileRequestDto {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final MultipartFile? photo;

  const UpdateUserProfileRequestDto({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    this.photo,
  });

  /// Factory Mapper: Converts Domain Params to Data Multipart DTO
  static Future<UpdateUserProfileRequestDto> fromParams(
      UpdateUserProfileParams params,
      ) async {
    MultipartFile? file;
    if (params.photoFilePath != null && params.photoFilePath!.isNotEmpty) {
      file = await MultipartFile.fromFile(params.photoFilePath!);
    }

    return UpdateUserProfileRequestDto(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      gender: params.gender,
      photo: file,
    );
  }

  /// Converts fields into a multipart map for @PartMap()
  Map<String, dynamic> toMap() => {
    'FullName': fullName,
    'Email': email,
    'Phone': phone,
    'Gender': gender,
    if (photo != null) 'Photo': photo,
  };
}