import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/base/ui_events.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/app_theme/app_colors.dart';
import '../../../../../core/validation/validation.dart';
import '../../../../../generated/locale_keys.g.dart';

import '../../../data/models/register_request_dto.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../manager/register_cubit.dart';
import '../manager/register_intents.dart';
import '../manager/register_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with UiEventMixin<RegisterView, RegisterState, UiEvent> {
  // Required by UiEventMixin
  @override
  late final RegisterCubit cubit = getIt<RegisterCubit>();

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    cubit.close();
    super.dispose();
  }

  void _onSubmit(RegisterState state) {
    if (_formKey.currentState?.validate() ?? false) {
      final request = RegisterRequestDto(
        firstName: _firstNameController.text.trim(),
        lastName: _secondNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        gender: state.gender,
        vehicleType: state.selectedVehicleType?.id ?? 'car',
        vehicleNumber: _vehicleNumberController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        vehicleLicense: state.licensePhotoPath,
        idImage: state.idImagePath,
      );
      cubit.onIntent(SubmitRegisterIntent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          // When registration succeeds, show the Figma Success screen
          if (state.registerResource.isSuccess) {
            return _buildSuccessApplyScreen();
          }

          final countries = state.countriesResource.data ?? [];
          final vehicleTypes = state.vehicleTypesResource.data ?? [];

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(
                LocaleKeys.apply_title.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.apply_welcome_header.tr(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LocaleKeys.apply_welcome_sub.tr(),
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(height: 20),

                      // 1. Country Dropdown
                      DropdownButtonFormField<Country>(
                        value: state.selectedCountry,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_country_label.tr(),
                        ),
                        items: countries.map((c) {
                          return DropdownMenuItem<Country>(
                            value: c,
                            child: Row(
                              children: [
                                Text(c.flag, style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(c.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (c) {
                          if (c != null) cubit.onIntent(SelectCountryIntent(c));
                        },
                      ),
                      const SizedBox(height: 16),

                      // 2. First legal name
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_first_name_label.tr(),
                          hintText: LocaleKeys.apply_first_name_hint.tr(),
                        ),
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),

                      // 3. Second legal name
                      TextFormField(
                        controller: _secondNameController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_second_name_label.tr(),
                          hintText: LocaleKeys.apply_second_name_hint.tr(),
                        ),
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),

                      // 4. Vehicle Type Dropdown
                      DropdownButtonFormField<VehicleType>(
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
                          if (v != null) cubit.onIntent(SelectVehicleTypeIntent(v));
                        },
                      ),
                      const SizedBox(height: 16),

                      // 5. Vehicle number
                      TextFormField(
                        controller: _vehicleNumberController,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_vehicle_number_label.tr(),
                          hintText: LocaleKeys.apply_vehicle_number_hint.tr(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // 6. Vehicle License Upload
                      _buildUploadTile(
                        label: LocaleKeys.apply_vehicle_license_label.tr(),
                        hint: state.licensePhotoPath ?? LocaleKeys.apply_vehicle_license_hint.tr(),
                        onTap: () {
                          // File picker, then: cubit.onIntent(SetLicensePhotoIntent(path));
                        },
                      ),
                      const SizedBox(height: 16),

                      // 7. Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.auth_email_label.tr(),
                          hintText: LocaleKeys.auth_email_hint.tr(),
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // 8. Phone number
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_phone_label.tr(),
                          hintText: LocaleKeys.apply_phone_hint.tr(),
                        ),
                        validator: Validators.validatePhone,
                      ),
                      const SizedBox(height: 16),

                      // 9. ID number
                      TextFormField(
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.apply_id_number_label.tr(),
                          hintText: LocaleKeys.apply_id_number_hint.tr(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // 10. ID image upload
                      _buildUploadTile(
                        label: LocaleKeys.apply_id_image_label.tr(),
                        hint: state.idImagePath ?? LocaleKeys.apply_id_image_hint.tr(),
                        onTap: () {
                          // File picker, then: cubit.onIntent(SetIdImageIntent(path));
                        },
                      ),
                      const SizedBox(height: 16),

                      // 11. Passwords (side-by-side row matching Figma)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: state.isPasswordHidden,
                              decoration: InputDecoration(
                                labelText: LocaleKeys.auth_password_label.tr(),
                                hintText: LocaleKeys.auth_password_hint.tr(),
                              ),
                              validator: Validators.validatePassword,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: state.isConfirmPasswordHidden,
                              decoration: InputDecoration(
                                labelText: LocaleKeys.apply_confirm_password_label.tr(),
                                hintText: LocaleKeys.apply_confirm_password_hint.tr(),
                              ),
                              validator: (v) => Validators.validateConfirmPassword(
                                v,
                                _passwordController.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 12. Gender Radio Buttons
                      Row(
                        children: [
                          Text(
                            LocaleKeys.common_gender.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          Radio<String>(
                            value: 'female',
                            groupValue: state.gender,
                            activeColor: AppColors.pink,
                            onChanged: (val) => cubit.onIntent(SelectGenderIntent(val!)),
                          ),
                          Text('common.female'.tr()),
                          const SizedBox(width: 12),
                          Radio<String>(
                            value: 'male',
                            groupValue: state.gender,
                            activeColor: AppColors.pink,
                            onChanged: (val) => cubit.onIntent(SelectGenderIntent(val!)),
                          ),
                          Text('common.male'.tr()),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 13. Continue Button
                      ElevatedButton(
                        onPressed: state.registerResource.isLoading
                            ? null
                            : () => _onSubmit(state),
                        child: state.registerResource.isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(LocaleKeys.common_continue.tr()),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadTile({
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.file_upload_outlined, color: Colors.grey),
        ),
        child: Text(
          hint,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildSuccessApplyScreen() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.pink, width: 3),
                ),
                child: const Icon(Icons.check, size: 50, color: AppColors.pink),
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.apply_submitted_title.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.apply_submitted_desc.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: Text(LocaleKeys.common_login.tr()),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}