import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/auth/presentation/register/view/registeration_success_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'apply': {
        'submitted_title': 'Application Submitted Successfully!',
        'submitted_desc': 'Thank you for applying.',
      },
      'common': {
        'login': 'Log In',
      }
    };
  }
}

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  Widget buildSuccessWidget({GoRouter? router}) {
    final testRouter = router ??
        GoRouter(
          initialLocation: AppRoutes.registrationSuccess,
          routes: [
            GoRoute(
              path: AppRoutes.registrationSuccess,
              builder: (context, state) => const RegistrationSuccessView(),
            ),
            GoRoute(
              path: AppRoutes.login,
              builder: (context, state) => const Scaffold(
                body: Text('Login Screen'),
              ),
            ),
          ],
        );

    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      assetLoader: const TestAssetLoader(),
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: testRouter,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }

  group('RegistrationSuccessView Widget Tests', () {
    testWidgets('renders success title, description, and login button', (tester) async {
      await tester.pumpWidget(buildSuccessWidget());
      await tester.pumpAndSettle();

      expect(find.text('Application Submitted Successfully!'), findsOneWidget);
      expect(find.text('Thank you for applying.'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('navigates to login route when Log In button is tapped', (tester) async {
      var navigatedToLogin = false;

      final router = GoRouter(
        initialLocation: AppRoutes.registrationSuccess,
        routes: [
          GoRoute(
            path: AppRoutes.registrationSuccess,
            builder: (context, state) => const RegistrationSuccessView(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) {
              navigatedToLogin = true;
              return const Scaffold(body: Text('Login Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(buildSuccessWidget(router: router));
      await tester.pumpAndSettle();

      final loginButton = find.text('Log In');
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(navigatedToLogin, isTrue);
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
