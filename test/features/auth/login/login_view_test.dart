import 'package:driver_app/features/auth/presentation/login/login_view.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

Widget _makeTestable(Widget child) {
  return MaterialApp(
    home: child,
  );
}

void main() {
  late MockLoginCubit mockCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockCubit = MockLoginCubit();
    // Stub the state and stream
    when(() => mockCubit.state).thenReturn(const LoginState());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.eventStream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});

    final getIt = GetIt.instance;
    if (getIt.isRegistered<LoginCubit>()) {
      getIt.unregister<LoginCubit>();
    }
    getIt.registerSingleton<LoginCubit>(mockCubit);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('LoginView Widget Tests', () {
    testWidgets('renders email, password fields and buttons', (tester) async {
      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('rememberMeCheckbox')), findsOneWidget);
      expect(find.byKey(const Key('forgotPasswordBtn')), findsOneWidget);
      expect(find.byKey(const Key('continueBtn')), findsOneWidget);
    });

    testWidgets('continue button is disabled when form is empty', (tester) async {
      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      final continueBtn = tester.widget<ElevatedButton>(find.byKey(const Key('continueBtn')));
      expect(continueBtn.onPressed, isNull);
    });

    testWidgets('continue button is enabled when form is valid', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(email: 'test@test.com', password: 'Password123'),
      );

      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      final continueBtn = tester.widget<ElevatedButton>(find.byKey(const Key('continueBtn')));
      expect(continueBtn.onPressed, isNotNull);
    });
  });
}
