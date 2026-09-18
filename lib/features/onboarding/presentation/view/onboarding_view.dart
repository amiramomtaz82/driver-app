import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/locale_keys.g.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/images/delivery.png',
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                LocaleKeys.onboarding_welcome_title.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.onboarding_app_name.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.login),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: AppColors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  LocaleKeys.common_login.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.register),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.black54, width: 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  LocaleKeys.onboarding_apply_now.tr(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'v 6.3.0 - (446)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
