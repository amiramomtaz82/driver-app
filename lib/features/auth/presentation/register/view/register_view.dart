import 'package:driver_app/features/auth/domain/entities/register_entity.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/country_dropdowen_field.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/document_uploade_tile.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/geneder_selction.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/password_field_section.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/register_header_section.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/vehichle_type_dropdowen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/validation/validation.dart';
import '../../../../../generated/locale_keys.g.dart';

import '../manager/register_cubit.dart';
import '../manager/register_intents.dart';
import '../manager/register_state.dart';



import 'widgets/register_submit_button.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with UiEventMixin<RegisterView, RegisterState, UiEvent> {
  @override
  late final RegisterCubit cubit;

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
  void initState() {
    cubit = context.read<RegisterCubit>();
    super.initState();
    cubit.onIntent(const LoadDropdownDataIntent());
  }

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
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = cubit.state;
      final params = RegisterEntity(
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
      cubit.onIntent(SubmitRegisterIntent(params));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const RegisterHeaderSection(),
                const SizedBox(height: 20),

                // Country Dropdown
                const CountryDropdownField(),
                const SizedBox(height: 16),

                // First Legal Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.apply_first_name_label.tr(),
                    hintText: LocaleKeys.apply_first_name_hint.tr(),
                  ),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                // Second Legal Name
                TextFormField(
                  controller: _secondNameController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.apply_second_name_label.tr(),
                    hintText: LocaleKeys.apply_second_name_hint.tr(),
                  ),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                // Vehicle Type Dropdown
                const VehicleTypeDropdownField(),
                const SizedBox(height: 16),

                // Vehicle Number
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.apply_vehicle_number_label.tr(),
                    hintText: LocaleKeys.apply_vehicle_number_hint.tr(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Vehicle License Upload Tile
                BlocBuilder<RegisterCubit, RegisterState>(
                  buildWhen: (prev, curr) =>
                  prev.licensePhotoPath != curr.licensePhotoPath,
                  builder: (context, state) => DocumentUploadTile(
                    label: LocaleKeys.apply_vehicle_license_label.tr(),
                    hint: LocaleKeys.apply_vehicle_license_hint.tr(),
                    filePath: state.licensePhotoPath,
                    onSourceSelected: (source) =>
                        cubit.onIntent(PickLicensePhotoIntent(source)),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
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

                // Phone Number
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

                // National ID Number
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

                // National ID Image Upload Tile
                BlocBuilder<RegisterCubit, RegisterState>(
                  buildWhen: (prev, curr) =>
                  prev.idImagePath != curr.idImagePath,
                  builder: (context, state) => DocumentUploadTile(
                    label: LocaleKeys.apply_id_image_label.tr(),
                    hint: LocaleKeys.apply_id_image_hint.tr(),
                    filePath: state.idImagePath,
                    onSourceSelected: (source) =>
                        cubit.onIntent(PickIdImageIntent(source)),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Fields (side-by-side)
                PasswordFieldsSection(
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),
                const SizedBox(height: 16),

                // Gender Radio Buttons
                const GenderSelectorSection(),
                const SizedBox(height: 24),

                // Submit Button
                RegisterSubmitButton(onPressed: _onSubmit),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}