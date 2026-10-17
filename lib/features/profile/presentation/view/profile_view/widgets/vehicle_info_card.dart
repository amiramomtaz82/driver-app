import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/context_extension.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../domain/entities/driver_vehicle_entity.dart';

class VehicleInfoCard extends StatelessWidget {
  final DriverVehicleEntity? vehicle;
  final VoidCallback onTap;

  const VehicleInfoCard({
    super.key,
    required this.vehicle,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.profile_vehicle_info.tr(),
                      style:textTheme.titleMedium
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vehicle != null && vehicle!.vehicleType.trim().isNotEmpty
                          ? vehicle!.vehicleType
                          : 'Unknown',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle != null && vehicle!.vehicleNumber.trim().isNotEmpty
                          ? vehicle!.vehicleNumber
                          : 'Unknown',
                      style: textTheme.bodyLarge,
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