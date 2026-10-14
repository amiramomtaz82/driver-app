import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../auth/domain/entities/vehicle_type_entity.dart';
import '../../../manager/profile_cubit.dart';
import '../../../manager/profile_intents.dart';
import '../../../manager/profile_state.dart';

class VehicleTypeDropdownField extends StatelessWidget {
  const VehicleTypeDropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) =>
      prev.vehicleTypesResource != curr.vehicleTypesResource ||
          prev.selectedVehicleType != curr.selectedVehicleType,
      builder: (context, state) {
        final types = state.vehicleTypesResource.data ?? [];
        final isLoading = state.vehicleTypesResource.isLoading;

        // Ensure value exists in items list to avoid crashes:
        final selectedValue = types.contains(state.selectedVehicleType)
            ? state.selectedVehicleType
            : (types.isNotEmpty ? types.first : null);

        return DropdownButtonFormField<VehicleType>(
          value: selectedValue,
          hint: Text(isLoading ? 'Loading vehicle types...' : 'Select vehicle type'),
          decoration: InputDecoration(
            labelText: LocaleKeys.apply_vehicle_type_label.tr(),
            border: const OutlineInputBorder(),
            // 👇 Shows a spinner while fetching vehicle types from the API
            suffixIcon: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : null,
          ),
          items: types.map((type) {
            return DropdownMenuItem<VehicleType>(
              value: type,
              child: Text(type.name),
            );
          }).toList(),
          onChanged: isLoading
              ? null
              : (v) {
            if (v != null) {
              context.read<ProfileCubit>().onIntent(VehicleTypeSelected(v));
            }
          },
        );
      },
    );
  }
}