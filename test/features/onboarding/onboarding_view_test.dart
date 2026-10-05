import 'dart:convert';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.startsWith('assets/animations/')) {
      final lottieJson = {"v":"5.5.2","fr":29.9700012207031,"ip":0,"op":60,"w":800,"h":800,"nm":"Empty","ddd":0,"assets":[],"layers":[]};
      final bytes = utf8.encode(jsonEncode(lottieJson));
      return ByteData.view(Uint8List.fromList(bytes).buffer);
    }
    return rootBundle.load(key);
  }
}

Widget _makeTestable(Widget child, {GoRouter? router}) {
  final testRouter = router ??
      GoRouter(
        initialLocation: AppRoutes.onboarding,
        routes: [
          GoRoute(
            path: AppRoutes.onboarding,
            name: AppRoutes.onboarding,
            builder: (_, _a) => child,
          ),
          GoRoute(
            path: AppRoutes.login,
            name: AppRoutes.login,
            builder: (_, _a) => const Scaffold(body: Text('Login')),
          ),
          GoRoute(
            path: AppRoutes.register,
            name: AppRoutes.register,
            builder: (_, _a) => const Scaffold(body: Text('Register')),
          ),
        ],
      );

  return DefaultAssetBundle(
    bundle: TestAssetBundle(),
    child: MaterialApp.router(routerConfig: testRouter),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('OnboardingView ', () {
    testWidgets('shows delivery image (Lottie animation)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      expect(
        find.byType(LottieBuilder),
        findsOneWidget,
      );
    });

    testWidgets('shows Login and Apply now buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('tapping Login button navigates to /login', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('tapping Apply now button navigates to /register', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_makeTestable(const OnboardingView()));
      await tester.pump();

      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
    });
  });
}
