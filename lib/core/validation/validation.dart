
import 'package:easy_localization/easy_localization.dart';

abstract final class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{7,15}$',
  );

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'errors.validation.name_required'.tr();
    }
    if (value.trim().length < 2) {
      return 'errors.validation.name_too_short'.tr();
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'errors.validation.email_required'.tr();
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'errors.validation.email_invalid'.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'errors.validation.password_required'.tr();
    }
    if (value.length < 8) {
      return 'errors.validation.password_too_short'.tr();
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'errors.validation.password_needs_letter'.tr();
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'errors.validation.password_needs_number'.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'errors.validation.confirm_password_required'.tr();
    }
    if (value != originalPassword) {
      return 'errors.validation.passwords_do_not_match'.tr();
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'errors.validation.phone_required'.tr();
    }
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegExp.hasMatch(cleanPhone)) {
      return 'errors.validation.phone_invalid'.tr();
    }
    return null;
  }
}