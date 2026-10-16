import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/entities/reset_token_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_intents.dart';
import 'package:driver_app/features/auth/presentation/forget_password/manager/forget_password_state.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockForgetPasswordUseCase mockForgetPassword;
  late MockVerifyOtpUseCase mockVerifyOtp;
  late MockResetPasswordUseCase mockResetPassword;
  late ForgetPasswordCubit cubit;

  const email = 'test@test.com';
  const message = AuthMessageEntity(message: 'ok');
  final validToken = ResetToken(
    token: 'token',
    expiresAt: DateTime.now().add(const Duration(minutes: 10)),
  );
  final expiredToken = ResetToken(
    token: 'token',
    expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
  );

  setUp(() {
    mockForgetPassword = MockForgetPasswordUseCase();
    mockVerifyOtp = MockVerifyOtpUseCase();
    mockResetPassword = MockResetPasswordUseCase();
    cubit = ForgetPasswordCubit(
      mockForgetPassword,
      mockVerifyOtp,
      mockResetPassword,
    );
  });

  tearDown(() => cubit.close());

  group('ForgetPasswordCubit —', () {
    test('initial state is correct', () {
      expect(cubit.state, const ForgetPasswordState());
    });

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'emits trimmed email on EmailChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const EmailChanged(' $email ')),
      expect: () => [const ForgetPasswordState(email: email)],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'moves to the otp step and starts the cooldown on SendCodeSubmitted — success',
      build: () {
        when(
          () => mockForgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const SuccessResponse(message));
        return cubit;
      },
      seed: () => const ForgetPasswordState(email: email),
      act: (c) => c.onIntent(const SendCodeSubmitted()),
      expect: () => [
        const ForgetPasswordState(
          email: email,
          sendCodeResource: Resource.loading(),
        ),
        const ForgetPasswordState(
          email: email,
          step: ForgetPasswordStep.otp,
          resendCooldown: ForgetPasswordCubit.resendCooldownSeconds,
          sendCodeResource: Resource.success(message),
        ),
      ],
      verify: (_) => verify(() => mockForgetPassword(email: email)),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'counts the resend cooldown down every second',
      build: () {
        when(
          () => mockForgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => const SuccessResponse(message));
        return cubit;
      },
      seed: () => const ForgetPasswordState(email: email),
      act: (c) => c.onIntent(const SendCodeSubmitted()),
      wait: const Duration(milliseconds: 2500),
      skip: 2,
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.resendCooldown,
          'resendCooldown',
          ForgetPasswordCubit.resendCooldownSeconds - 1,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.resendCooldown,
          'resendCooldown',
          ForgetPasswordCubit.resendCooldownSeconds - 2,
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'stays on the email step and shows a snackbar on SendCodeSubmitted — failure',
      build: () {
        when(
          () => mockForgetPassword(email: any(named: 'email')),
        ).thenAnswer((_) async => ErrorResponse(errMessage: 'Email not found'));
        return cubit;
      },
      seed: () => const ForgetPasswordState(email: email),
      act: (c) => c.onIntent(const SendCodeSubmitted()),
      expect: () => [
        const ForgetPasswordState(
          email: email,
          sendCodeResource: Resource.loading(),
        ),
        const ForgetPasswordState(
          email: email,
          sendCodeResource: Resource.error('Email not found'),
        ),
      ],
      verify: (c) => expectLater(
        c.eventStream,
        emits(
          isA<ShowSnackBarEvent>()
              .having((e) => e.message, 'message', 'Email not found')
              .having((e) => e.isError, 'isError', true),
        ),
      ),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'ignores ResendCodeTapped while the cooldown is running',
      build: () => cubit,
      seed: () => const ForgetPasswordState(
        email: email,
        step: ForgetPasswordStep.otp,
        resendCooldown: 10,
      ),
      act: (c) => c.onIntent(const ResendCodeTapped()),
      expect: () => <ForgetPasswordState>[],
      verify: (_) => verifyNever(
        () => mockForgetPassword(email: any(named: 'email')),
      ),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'keeps the reset token and moves to the reset step on OtpCompleted — success',
      build: () {
        when(
          () => mockVerifyOtp(
            email: any(named: 'email'),
            otpCode: any(named: 'otpCode'),
          ),
        ).thenAnswer((_) async => SuccessResponse(validToken));
        return cubit;
      },
      seed: () =>
          const ForgetPasswordState(email: email, step: ForgetPasswordStep.otp),
      act: (c) => c.onIntent(const OtpCompleted('123456')),
      expect: () => [
        const ForgetPasswordState(
          email: email,
          step: ForgetPasswordStep.otp,
          verifyOtpResource: Resource.loading(),
        ),
        ForgetPasswordState(
          email: email,
          step: ForgetPasswordStep.resetPassword,
          verifyOtpResource: Resource.success(validToken),
        ),
      ],
      verify: (_) =>
          verify(() => mockVerifyOtp(email: email, otpCode: '123456')),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'shows the error inline on OtpCompleted — failure',
      build: () {
        when(
          () => mockVerifyOtp(
            email: any(named: 'email'),
            otpCode: any(named: 'otpCode'),
          ),
        ).thenAnswer((_) async => ErrorResponse(errMessage: 'Invalid code'));
        return cubit;
      },
      seed: () =>
          const ForgetPasswordState(email: email, step: ForgetPasswordStep.otp),
      act: (c) => c.onIntent(const OtpCompleted('000000')),
      expect: () => [
        const ForgetPasswordState(
          email: email,
          step: ForgetPasswordStep.otp,
          verifyOtpResource: Resource.loading(),
        ),
        isA<ForgetPasswordState>()
            .having((s) => s.step, 'step', ForgetPasswordStep.otp)
            .having((s) => s.otpErrorMessage, 'otpErrorMessage', 'Invalid code'),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'shows the invalid code message when the server rejects the otp with a 500',
      build: () {
        final serverError = DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            data: {'error': 'Cannot access Value of a failed result.'},
          ),
        );
        when(
          () => mockVerifyOtp(
            email: any(named: 'email'),
            otpCode: any(named: 'otpCode'),
          ),
        ).thenAnswer((_) async => ErrorResponse(error: serverError));
        return cubit;
      },
      seed: () =>
          const ForgetPasswordState(email: email, step: ForgetPasswordStep.otp),
      act: (c) => c.onIntent(const OtpCompleted('000000')),
      skip: 1,
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.otpErrorMessage,
          'otpErrorMessage',
          LocaleKeys.forget_password_invalid_code,
        ),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'clears the otp error on OtpChanged',
      build: () => cubit,
      seed: () => const ForgetPasswordState(
        step: ForgetPasswordStep.otp,
        verifyOtpResource: Resource.error('Invalid code'),
      ),
      act: (c) => c.onIntent(const OtpChanged()),
      expect: () => [
        const ForgetPasswordState(step: ForgetPasswordStep.otp),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'navigates to login on ResetPasswordSubmitted — success',
      build: () {
        when(
          () => mockResetPassword(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          ),
        ).thenAnswer((_) async => const SuccessResponse(message));
        return cubit;
      },
      seed: () => ForgetPasswordState(
        email: email,
        step: ForgetPasswordStep.resetPassword,
        newPassword: 'Pass1234',
        confirmPassword: 'Pass1234',
        verifyOtpResource: Resource.success(validToken),
      ),
      act: (c) => c.onIntent(const ResetPasswordSubmitted()),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.resetPasswordResource.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.resetPasswordResource.isSuccess,
          'isSuccess',
          true,
        ),
      ],
      verify: (c) async {
        verify(
          () => mockResetPassword(
            resetToken: 'token',
            newPassword: 'Pass1234',
            confirmNewPassword: 'Pass1234',
          ),
        );
        await expectLater(
          c.eventStream,
          emits(
            isA<NavigateReplacementEvent>().having(
              (e) => e.route,
              'route',
              AppRoutes.login,
            ),
          ),
        );
      },
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'shows a snackbar on ResetPasswordSubmitted — failure',
      build: () {
        when(
          () => mockResetPassword(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          ),
        ).thenAnswer((_) async => ErrorResponse(errMessage: 'Weak password'));
        return cubit;
      },
      seed: () => ForgetPasswordState(
        step: ForgetPasswordStep.resetPassword,
        newPassword: 'Pass1234',
        confirmPassword: 'Pass1234',
        verifyOtpResource: Resource.success(validToken),
      ),
      act: (c) => c.onIntent(const ResetPasswordSubmitted()),
      skip: 1,
      expect: () => [
        isA<ForgetPasswordState>()
            .having((s) => s.step, 'step', ForgetPasswordStep.resetPassword)
            .having(
              (s) => s.resetPasswordResource.errorMessage,
              'errorMessage',
              'Weak password',
            ),
      ],
      verify: (c) => expectLater(
        c.eventStream,
        emits(
          isA<ShowSnackBarEvent>()
              .having((e) => e.message, 'message', 'Weak password')
              .having((e) => e.isError, 'isError', true),
        ),
      ),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'goes back to the otp step when the reset token has expired',
      build: () => cubit,
      seed: () => ForgetPasswordState(
        email: email,
        step: ForgetPasswordStep.resetPassword,
        newPassword: 'Pass1234',
        confirmPassword: 'Pass1234',
        verifyOtpResource: Resource.success(expiredToken),
      ),
      act: (c) => c.onIntent(const ResetPasswordSubmitted()),
      expect: () => [
        isA<ForgetPasswordState>()
            .having((s) => s.step, 'step', ForgetPasswordStep.otp)
            .having((s) => s.resetToken, 'resetToken', isNull)
            .having(
              (s) => s.otpErrorMessage,
              'otpErrorMessage',
              LocaleKeys.forget_password_reset_session_expired,
            ),
      ],
      verify: (_) => verifyNever(
        () => mockResetPassword(
          resetToken: any(named: 'resetToken'),
          newPassword: any(named: 'newPassword'),
          confirmNewPassword: any(named: 'confirmNewPassword'),
        ),
      ),
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'goes to the previous step on BackPressed',
      build: () => cubit,
      seed: () => const ForgetPasswordState(step: ForgetPasswordStep.otp),
      act: (c) => c.onIntent(const BackPressed()),
      expect: () => [const ForgetPasswordState()],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordState>(
      'pops the screen on BackPressed from the email step',
      build: () => cubit,
      act: (c) => c.onIntent(const BackPressed()),
      expect: () => <ForgetPasswordState>[],
      verify: (c) => expectLater(c.eventStream, emits(isA<PopEvent>())),
    );
  });
}
