import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/app_theme/app_colors.dart';
import '../../../../../../core/app_theme/context_extension.dart';
import '../../../manager/profile_cubit.dart';
import '../../../manager/profile_intents.dart';
import '../../../manager/profile_state.dart';
import 'avatar_source_bottom_sheet.dart';

class EditUserAvatarPicker extends StatelessWidget {
  const EditUserAvatarPicker({super.key});

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AvatarSourceBottomSheet(
        onSourceSelected: (source) {
          context.read<ProfileCubit>().onIntent(PickUserPhotoIntent(source));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) =>
      prev.editPhotoPath != curr.editPhotoPath ||
          prev.profileResource != curr.profileResource,
      builder: (context, state) {
        final localPath = state.editPhotoPath;
        final networkUrl = state.profileResource.data?.photoUrl;

        ImageProvider? image;
        if (localPath != null && localPath.isNotEmpty) {
          image = FileImage(File(localPath));
        } else if (networkUrl != null && networkUrl.isNotEmpty) {
          image = NetworkImage(networkUrl);
        }

        return Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: colors.divider,
                backgroundImage: image,
                child: image == null ? Icon(Icons.person, size: 50, color: colors.white) : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => _showSourceSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}