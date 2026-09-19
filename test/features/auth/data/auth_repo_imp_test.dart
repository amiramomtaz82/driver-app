import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/data/data_source/local_data_source.dart';
import 'package:driver_app/features/auth/data/data_source/remote_data_source.dart';
import 'package:driver_app/features/auth/data/models/message_response_model.dart';
import 'package:driver_app/features/auth/data/models/verify_otp_response_model.dart';
import 'package:driver_app/features/auth/data/repo/auth_repo_imp.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/entities/reset_token_entity.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late AuthRepoImpl repo;

  const email = 'test@test.com';
  final expiresAt = DateTime.utc(2026, 9, 19, 15, 10);

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(mockRemote, MockAuthLocalDataSource());
  });

  group('AuthRepoImpl —', () {
    group('forgetPassword', () {
      test('returns the message entity on success', () async {
        when(() => mockRemote.forgetPassword(email: email)).thenAnswer(
          (_) async => const MessageResponseModel(message: 'sent'),
        );

        final result = await repo.forgetPassword(email: email);

        expect(result, isA<SuccessResponse<AuthMessageEntity>>());
        expect(
          (result as SuccessResponse<AuthMessageEntity>).data,
          const AuthMessageEntity(message: 'sent'),
        );
      });

      test('returns an error response when the call throws', () async {
        when(
          () => mockRemote.forgetPassword(email: email),
        ).thenThrow(Exception('boom'));

        final result = await repo.forgetPassword(email: email);

        expect(
          result,
          isA<ErrorResponse<AuthMessageEntity>>().having(
            (e) => e.errMessage,
            'errMessage',
            LocaleKeys.errors_something_went_wrong,
          ),
        );
      });
    });

    group('verifyOtp', () {
      test('returns the reset token entity on success', () async {
        when(
          () => mockRemote.verifyOtp(email: email, otpCode: '123456'),
        ).thenAnswer(
          (_) async => VerifyOtpResponseData(
            resetToken: 'token',
            expirationDate: expiresAt,
          ),
        );

        final result = await repo.verifyOtp(email: email, otpCode: '123456');

        expect(
          (result as SuccessResponse<ResetToken>).data,
          ResetToken(token: 'token', expiresAt: expiresAt),
        );
      });

      test('returns an error response when the call throws', () async {
        when(
          () => mockRemote.verifyOtp(email: email, otpCode: '000000'),
        ).thenThrow(Exception('boom'));

        final result = await repo.verifyOtp(email: email, otpCode: '000000');

        expect(result, isA<ErrorResponse<ResetToken>>());
      });
    });

    group('resetPassword', () {
      test('passes the token and passwords and returns the message', () async {
        when(
          () => mockRemote.resetPassword(
            resetToken: 'token',
            newPassword: 'Pass1234',
            confirmNewPassword: 'Pass1234',
          ),
        ).thenAnswer((_) async => const MessageResponseModel(message: 'done'));

        final result = await repo.resetPassword(
          resetToken: 'token',
          newPassword: 'Pass1234',
          confirmNewPassword: 'Pass1234',
        );

        expect(
          (result as SuccessResponse<AuthMessageEntity>).data,
          const AuthMessageEntity(message: 'done'),
        );
      });

      test('returns an error response when the call throws', () async {
        when(
          () => mockRemote.resetPassword(
            resetToken: any(named: 'resetToken'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          ),
        ).thenThrow(Exception('boom'));

        final result = await repo.resetPassword(
          resetToken: 'token',
          newPassword: 'Pass1234',
          confirmNewPassword: 'Pass1234',
        );

        expect(result, isA<ErrorResponse<AuthMessageEntity>>());
      });
    });
  });
}
