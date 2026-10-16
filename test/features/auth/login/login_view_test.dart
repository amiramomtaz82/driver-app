import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/presentation/login/login_view.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

Widget _makeTestable(Widget child) {
  return MaterialApp(home: child);
}

void main() {
  late MockLoginCubit mockCubit;

  setUp(() {
    mockCubit = MockLoginCubit();
    when(() => mockCubit.state).thenReturn(const LoginState());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.eventStream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});

    final getIt = GetIt.instance;
    if (getIt.isRegistered<LoginCubit>()) getIt.unregister<LoginCubit>();
    getIt.registerSingleton<LoginCubit>(mockCubit);
  });

  tearDown(() => GetIt.instance.reset());

  group('LoginView Widget Tests —', () {
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

      final continueBtn = tester.widget<ElevatedButton>(
        find.byKey(const Key('continueBtn')),
      );
      expect(continueBtn.onPressed, isNull);
    });

    testWidgets('continue button is enabled when form is valid', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(email: 'test@test.com', password: 'Password123'),
      );

      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      final continueBtn = tester.widget<ElevatedButton>(
        find.byKey(const Key('continueBtn')),
      );
      expect(continueBtn.onPressed, isNotNull);
    });

    testWidgets('shows loading indicator when state is loading', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(
          email: 'test@test.com',
          password: 'Password123',
          loginResource: Resource.loading(),
        ),
      );

      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('email field shows validation error on invalid input', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(email: 'bademail', password: 'Password123'),
      );

      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      final emailFinder = find.descendant(
        of: find.byKey(const Key('emailField')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(emailFinder, 'bademail');

      final passwordFinder = find.descendant(
        of: find.byKey(const Key('passwordField')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(passwordFinder, 'Password123');
      await tester.pumpAndSettle();

      final continueBtn = find.byKey(const Key('continueBtn'));
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('errors.validation.email_invalid'), findsOneWidget);
    });

    testWidgets('password field shows validation error on short password', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const LoginState(email: 'test@test.com', password: '12'),
      );

      await tester.pumpWidget(_makeTestable(const LoginView()));
      await tester.pumpAndSettle();

      final emailFinder = find.descendant(
        of: find.byKey(const Key('emailField')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(emailFinder, 'test@test.com');

      final passwordFinder = find.descendant(
        of: find.byKey(const Key('passwordField')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(passwordFinder, '12');
      await tester.pumpAndSettle();

      final continueBtn = find.byKey(const Key('continueBtn'));
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('errors.validation.password_too_short'), findsOneWidget);
    });
  });
}
