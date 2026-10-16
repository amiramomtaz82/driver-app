import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../generated/locale_keys.g.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                _SuccessCheck(color: colors.success),
                const SizedBox(height: 28),
                Text(
                  LocaleKeys.orders_thank_you.tr(),
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.orders_order_delivered_successfully.tr(),
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: Text(LocaleKeys.common_done.tr()),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessCheck extends StatelessWidget {
  const _SuccessCheck({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.22),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}
