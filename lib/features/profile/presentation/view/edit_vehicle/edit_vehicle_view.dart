import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/app_theme/app_colors.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../manager/profile_cubit.dart';
import '../../manager/profile_intents.dart';
import '../../manager/profile_state.dart';
import 'widgets/update_vehicle_button.dart';
import 'widgets/vehicle_license_upload.dart';
import 'widgets/vehicle_number_field.dart';
import 'widgets/vehicle_type_dropdown.dart';

class EditVehicleView extends StatefulWidget {
  const EditVehicleView({super.key});

  @override
  State<EditVehicleView> createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends State<EditVehicleView>
    with UiEventMixin<EditVehicleView, ProfileState, UiEvent> {
  late final TextEditingController _plateNumberController;

  @override
  BaseCubit<ProfileState, UiEvent> get cubit => context.read<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    final currentVehicle = context.read<ProfileCubit>().state.profileResource.data?.vehicle;
    _plateNumberController = TextEditingController(text: currentVehicle?.vehicleNumber ?? '');
    context.read<ProfileCubit>().onIntent(const InitVehicleEditForm());
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_edit_profile.tr()),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              backgroundColor: AppColors.pink,
              child: Icon(Icons.notifications_none_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              const VehicleTypeDropdownField(),
              const SizedBox(height: 16),
              VehicleNumberField(
                controller: _plateNumberController,
                onChanged: (v) => cubit.onIntent(VehicleNumberChanged(v)),
              ),
              const SizedBox(height: 16),
              const VehicleLicenseUploadTile(),
              const SizedBox(height: 48),
              UpdateVehicleButton(
                isValid: state.isVehicleEditValid,
                isLoading: state.updateVehicleResource.isLoading,
                onPressed: () => cubit.onIntent(const SubmitVehicleEdit()),
              ),
            ],
          );
        },
      ),
    );
  }
}