import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../auth/presentation/register/view/widgets/document_upload_tile.dart';
import '../../../manager/profile_cubit.dart';
import '../../../manager/profile_intents.dart';
import '../../../manager/profile_state.dart';

class VehicleLicenseUploadTile extends StatelessWidget {
  const VehicleLicenseUploadTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) => prev.editLicensePath != curr.editLicensePath,
      builder: (context, state) {
        return DocumentUploadTile(
          label: LocaleKeys.apply_vehicle_license_label.tr(),
          filePath: state.editLicensePath,
          hint: LocaleKeys.apply_vehicle_license_hint.tr(),
          onSourceSelected: (source) {
            context.read<ProfileCubit>().onIntent(
              PickVehicleLicenseIntent(source),
            );
          },
        );
      },
    );
  }
}