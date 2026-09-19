import 'package:driver_app/features/auth/domain/models/message_response_model.dart';
import 'package:driver_app/features/auth/domain/models/verify_otp_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Forget password models —', () {
    test('MessageResponseModel reads the message from the value envelope', () {
      final model = MessageResponseModel.fromJson({
        'value': {'message': 'If this email is registered, a code has been sent.'},
        'isSuccess': true,
        'isFailure': false,
        'error': null,
      });

      expect(
        model.message,
        'If this email is registered, a code has been sent.',
      );
    });

    test('VerifyOtpResponseModel reads the reset token from the value envelope',
        () {
      final model = VerifyOtpResponseModel.fromJson({
        'value': {
          'resetToken': 'abc',
          'expirationDate': '2026-09-19T15:10:00Z',
        },
        'isSuccess': true,
        'isFailure': false,
        'error': null,
      });

      expect(model.value.resetToken, 'abc');
      expect(model.value.expiresAt, DateTime.utc(2026, 9, 19, 15, 10));
    });

    test('expirationDate without a zone is treated as UTC', () {
      final token = ResetTokenModel.fromJson({
        'resetToken': 'abc',
        'expirationDate': '2026-09-19T15:10:00',
      });

      expect(token.expiresAt, DateTime.utc(2026, 9, 19, 15, 10));
    });
  });
}
