import 'package:driver_app/features/auth/data/models/message_response_model.dart';
import 'package:driver_app/features/auth/data/models/verify_otp_response_model.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/entities/reset_token_entity.dart';
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
        model.toEntity(),
        const AuthMessageEntity(
          message: 'If this email is registered, a code has been sent.',
        ),
      );
    });

    test('VerifyOtpResponseModel maps the value envelope to a ResetToken', () {
      final model = VerifyOtpResponseModel.fromJson({
        'value': {
          'resetToken': 'abc',
          'expirationDate': '2026-09-19T15:10:00Z',
        },
        'isSuccess': true,
        'isFailure': false,
        'error': null,
      });

      expect(
        model.value.toEntity(),
        ResetToken(token: 'abc', expiresAt: DateTime.utc(2026, 9, 19, 15, 10)),
      );
    });

    test('fromJson reads an expirationDate without a zone as UTC', () {
      final data = VerifyOtpResponseData.fromJson({
        'resetToken': 'abc',
        'expirationDate': '2026-09-19T15:10:00',
      });

      expect(data.expirationDate.isUtc, isTrue);
      expect(data.expirationDate, DateTime.utc(2026, 9, 19, 15, 10));
    });
  });
}
