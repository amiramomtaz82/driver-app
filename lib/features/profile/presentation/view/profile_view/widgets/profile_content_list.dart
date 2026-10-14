import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/profile_version_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/go_routes/routes_names.dart';
import '../../../../domain/entities/driver_profile_entity.dart';
import '../../../manager/profile_cubit.dart';
import '../../../manager/profile_intents.dart';
import 'logout_tile.dart';

import 'settings_language_tile.dart';
import 'user_info_card.dart';
import 'vehicle_info_card.dart';

class ProfileContentList extends StatelessWidget {
  final DriverProfileEntity profile;
  final VoidCallback onLogoutTap;

  const ProfileContentList({
    super.key,
    required this.profile,
    required this.onLogoutTap,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileCubit>().onIntent(const ProfileRefreshed());
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                UserInfoCard(
                  profile: profile,
                  onTap: () => context.push(AppRoutes.editUserProfile),
                ),
                const SizedBox(height: 16),
                VehicleInfoCard(
                  vehicle: profile.vehicle,
                  onTap: () => context.push(AppRoutes.editVehicle),
                ),
                const SizedBox(height: 24),
                const SettingsLanguageTile(),
                const SizedBox(height: 8),
                LogoutTile(onTap: onLogoutTap),
              ],
            ),
          ),
        ),
        // 👇 Fixed at the bottom outside the scrollable list
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ProfileVersionText(),
          ),
        ),
      ],
    );
  }
}