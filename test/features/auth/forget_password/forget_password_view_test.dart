import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_intents.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:driver_app/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:driver_app/features/auth/presentation/forget_password/widgets/otp_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordCubit extends Mock implements ForgetPasswordCubit {}

Widget _makeTestable() {
  return const MaterialApp(home: ForgetPasswordView());
}

void main() {
  late MockForgetPasswordCubit mockCubit;

  const email = 'test@test.com';

  setUpAll(() {
    registerFallbackValue(const BackPressed());
  });

  void givenStates(
    ForgetPasswordState initialState, [
    List<ForgetPasswordState> states = const [],
  ]) {
    whenListen(
      mockCubit,
      Stream<ForgetPasswordState>.fromIterable(states),
      initialState: initialState,
    );
  }

  setUp(() {
    mockCubit = MockForgetPasswordCubit();
    when(() => mockCubit.eventStream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});
    givenStates(const ForgetPasswordState());

    GetIt.instance.registerSingleton<ForgetPasswordCubit>(mockCubit);
  });

  tearDown(() => GetIt.instance.reset());

  ElevatedButton buttonOf(WidgetTester tester, String key) {
    return tester.widget<ElevatedButton>(
      find.descendant(
        of: find.byKey(Key(key)),
        matching: find.byType(ElevatedButton),
      ),
    );
  }

  group('ForgetPasswordView —', () {
    group('email step', () {
      testWidgets('confirm is disabled while the email is empty', (
        tester,
      ) async {
        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('emailField')), findsOneWidget);
        expect(buttonOf(tester, 'sendCodeBtn').onPressed, isNull);
      });

      testWidgets('typing sends EmailChanged', (tester) async {
        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('emailField')), email);

        verify(
          () => mockCubit.onIntent(
            any(that: isA<EmailChanged>().having((i) => i.value, 'value', email)),
          ),
        ).called(1);
      });

      testWidgets('confirm with a valid email sends SendCodeSubmitted', (
        tester,
      ) async {
        givenStates(const ForgetPasswordState(email: email));

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('sendCodeBtn')));
        await tester.pump();

        verify(
          () => mockCubit.onIntent(any(that: isA<SendCodeSubmitted>())),
        ).called(1);
      });

      testWidgets('confirm with an invalid email does not send the code', (
        tester,
      ) async {
        givenStates(const ForgetPasswordState(email: 'not-an-email'));

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('sendCodeBtn')));
        await tester.pump();

        verifyNever(
          () => mockCubit.onIntent(any(that: isA<SendCodeSubmitted>())),
        );
      });

      testWidgets('back button sends BackPressed', (tester) async {
        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        await tester.tap(find.byType(BackButton));

        verify(
          () => mockCubit.onIntent(any(that: isA<BackPressed>())),
        ).called(1);
      });
    });

    group('otp step', () {
      const otpState = ForgetPasswordState(
        email: email,
        step: ForgetPasswordStep.otp,
        resendCooldown: 25,
      );

      testWidgets('moves to the otp step when the state changes', (
        tester,
      ) async {
        givenStates(const ForgetPasswordState(email: email), [otpState]);

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        expect(find.byType(OtpHolder), findsOneWidget);
        expect(find.byKey(const Key('emailField')), findsNothing);
      });

      testWidgets('resend is disabled and shows the countdown', (tester) async {
        givenStates(const ForgetPasswordState(email: email), [otpState]);

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        final resend = tester.widget<TextButton>(
          find.byKey(const Key('resendCodeBtn')),
        );
        expect(resend.onPressed, isNull);
        expect(find.textContaining('(25)'), findsOneWidget);
      });

      testWidgets('shows the verify error under the otp boxes', (tester) async {
        givenStates(const ForgetPasswordState(email: email), [
          otpState,
          otpState.copyWith(verifyOtpResource: const Resource.error('Wrong')),
        ]);

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();

        expect(find.text('Wrong'), findsOneWidget);
      });
    });

    group('reset password step', () {
      const resetState = ForgetPasswordState(
        email: email,
        step: ForgetPasswordStep.resetPassword,
        newPassword: 'Pass1234',
        confirmPassword: 'Pass1234',
      );

      testWidgets('confirm sends ResetPasswordSubmitted', (tester) async {
        givenStates(const ForgetPasswordState(email: email), [resetState]);

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('resetPasswordBtn')));
        await tester.pump();

        verify(
          () => mockCubit.onIntent(any(that: isA<ResetPasswordSubmitted>())),
        ).called(1);
      });

      testWidgets('confirm with mismatched passwords does not submit', (
        tester,
      ) async {
        givenStates(const ForgetPasswordState(email: email), [
          resetState.copyWith(confirmPassword: 'Other1234'),
        ]);

        await tester.pumpWidget(_makeTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('resetPasswordBtn')));
        await tester.pump();

        verifyNever(
          () => mockCubit.onIntent(any(that: isA<ResetPasswordSubmitted>())),
        );
      });
    });
  });
}
