import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../domain/entities/vehicle_type_entity.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_intents.dart';
import '../../manager/register_state.dart';

class VehicleTypeDropdownField extends StatelessWidget {
  const VehicleTypeDropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
      previous.vehicleTypesResource != current.vehicleTypesResource ||
          previous.selectedVehicleType != current.selectedVehicleType,
      builder: (context, state) {
        final vehicleTypes = state.vehicleTypesResource.data ?? [];
        return DropdownButtonFormField<VehicleType>(
          value: state.selectedVehicleType,
          decoration: InputDecoration(
            labelText: LocaleKeys.apply_vehicle_type_label.tr(),
          ),
          items: vehicleTypes.map((v) {
            return DropdownMenuItem<VehicleType>(
              value: v,
              child: Text(v.name),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              context.read<RegisterCubit>().onIntent(SelectVehicleTypeIntent(v));
            }
          },
        );
      },
    );
  }
}