import 'package:driver_app/core/app_theme/context_extension.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: colors.divider),
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => navigationShell.goBranch(
              index,
              // tapping the current tab again pops it back to its first screen
              initialLocation: index == navigationShell.currentIndex,
            ),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: LocaleKeys.nav_home.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.fact_check_outlined),
                selectedIcon: const Icon(Icons.fact_check),
                label: LocaleKeys.nav_orders.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: LocaleKeys.nav_profile.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
