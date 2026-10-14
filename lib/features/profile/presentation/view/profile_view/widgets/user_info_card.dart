import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/context_extension.dart';
import '../../../../domain/entities/driver_profile_entity.dart';

class UserInfoCard extends StatelessWidget {
  final DriverProfileEntity profile;
  final VoidCallback onTap;

  const UserInfoCard({
    super.key,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = context.theme.textTheme;

    return Card(
      elevation: 0,
color: colors.background,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.divider,width: 1),
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.divider,
                backgroundImage: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                    ? NetworkImage(profile.photoUrl!)
                    : null,
                child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                    ? Icon(Icons.person, size: 32, color: colors.grey)
                    :Icon(Icons.person,color: colors.grey,size: 30,),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style:textTheme.titleMedium
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style:textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.phone,
                      style:textTheme.bodyLarge ,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: colors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}