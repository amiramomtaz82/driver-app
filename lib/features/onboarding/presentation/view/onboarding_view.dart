import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
                child: Lottie.asset(
                  'assets/animations/delivery.json',
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                LocaleKeys.onboarding_welcome_title.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.onboarding_app_name.tr(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.login),
                child: Text(LocaleKeys.common_login.tr()),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.goNamed(AppRoutes.register),
                child: Text(LocaleKeys.onboarding_apply_now.tr()),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'v 6.3.0 - (446)',
                  style: Theme.of(context).textTheme.bodySmall,
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
