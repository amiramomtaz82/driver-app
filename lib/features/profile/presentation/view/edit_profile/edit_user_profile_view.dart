import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../manager/profile_cubit.dart';
import '../../manager/profile_intents.dart';
import '../../manager/profile_state.dart';
import 'widgets/edit_user_avatar_picker.dart';
import 'widgets/gender_selector.dart';
import 'widgets/name_fields_row.dart';
import 'widgets/update_user_profile_button.dart';
import 'widgets/user_email_field.dart';
import 'widgets/user_phone_field.dart';

class EditUserProfileView extends StatefulWidget {
  const EditUserProfileView({super.key});

  @override
  State<EditUserProfileView> createState() => _EditUserProfileViewState();
}

class _EditUserProfileViewState extends State<EditUserProfileView>
    with UiEventMixin<EditUserProfileView, ProfileState, UiEvent> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  @override
  BaseCubit<ProfileState, UiEvent> get cubit => context.read<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().state.profileResource.data;
    _firstNameController = TextEditingController(text: profile?.firstName ?? '');
    _lastNameController = TextEditingController(text: profile?.lastName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    context.read<ProfileCubit>().onIntent(const InitUserEditForm());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_edit_profile.tr()),
        centerTitle: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              const EditUserAvatarPicker(),
              const SizedBox(height: 20),
              NameFieldsRow(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                onFirstNameChanged: (v) => cubit.onIntent(FirstNameChanged(v)),
                onLastNameChanged: (v) => cubit.onIntent(LastNameChanged(v)),
              ),
              const SizedBox(height: 16),
              UserEmailField(email: state.editEmail),
              const SizedBox(height: 16),
              UserPhoneField(
                controller: _phoneController,
                onChanged: (v) => cubit.onIntent(PhoneChanged(v)),
              ),
              const SizedBox(height: 20),
              GenderSelector(
                selectedGender: state.editGender,
                onGenderChanged: (v) => cubit.onIntent(GenderChanged(v)),
              ),
              const SizedBox(height: 32),
              UpdateUserProfileButton(
                isValid: state.isUserEditValid,
                isLoading: state.updateUserResource.isLoading,
                onPressed: () => cubit.onIntent(const SubmitUserEdit()),
              ),
            ],
          );
        },
      ),
    );
  }
}