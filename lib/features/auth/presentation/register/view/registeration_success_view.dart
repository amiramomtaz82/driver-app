import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_theme/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../generated/locale_keys.g.dart';

class RegistrationSuccessView extends StatelessWidget {
  const RegistrationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // 1. Background wave image anchored at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              AppAssets.backGr,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          // 2. Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),


                 Image.asset(AppAssets.check, width:160, height: 160),
                  const SizedBox(height: 32),

                  // Title (Localized)
                  Text(
                    LocaleKeys.apply_submitted_title.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle description (Localized)
                  Text(
                    LocaleKeys.apply_submitted_desc.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.darkGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button (Localized)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(
                        LocaleKeys.common_login.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}