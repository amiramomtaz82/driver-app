import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:driver_app/features/auth/presentation/change_password/manager/change_password_cubit.dart';
import 'package:driver_app/features/auth/presentation/change_password/manager/change_password_intents.dart';
import 'package:driver_app/features/auth/presentation/change_password/manager/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  late MockChangePasswordUseCase mockUseCase;
  late ChangePasswordCubit cubit;

  setUp(() {
    mockUseCase = MockChangePasswordUseCase();
    cubit = ChangePasswordCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('ChangePasswordCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const ChangePasswordState());
    });

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits updated currentPassword on CurrentPasswordChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const CurrentPasswordChanged('OldPass123')),
      expect: () => [
        const ChangePasswordState(currentPassword: 'OldPass123'),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits updated newPassword on NewPasswordChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const NewPasswordChanged('NewPass123')),
      expect: () => [
        const ChangePasswordState(newPassword: 'NewPass123'),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits updated confirmPassword on ConfirmPasswordChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const ConfirmPasswordChanged('NewPass123')),
      expect: () => [
        const ChangePasswordState(confirmPassword: 'NewPass123'),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits loading then success on ChangePasswordSubmitted success',
      build: () {
        when(
          () => mockUseCase(
            currentPassword: 'OldPass123',
            newPassword: 'NewPass123',
            confirmNewPassword: 'NewPass123',
          ),
        ).thenAnswer(
          (_) async => const SuccessResponse(
            AuthMessageEntity(message: 'Password changed successfully.'),
          ),
        );
        return cubit;
      },
      seed: () => const ChangePasswordState(
        currentPassword: 'OldPass123',
        newPassword: 'NewPass123',
        confirmPassword: 'NewPass123',
      ),
      act: (c) => c.onIntent(const ChangePasswordSubmitted()),
      expect: () => [
        const ChangePasswordState(
          currentPassword: 'OldPass123',
          newPassword: 'NewPass123',
          confirmPassword: 'NewPass123',
          changePasswordResource: Resource.loading(),
        ),
        const ChangePasswordState(
          currentPassword: 'OldPass123',
          newPassword: 'NewPass123',
          confirmPassword: 'NewPass123',
          changePasswordResource: Resource.success(
            AuthMessageEntity(message: 'Password changed successfully.'),
          ),
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits loading then error on ChangePasswordSubmitted failure',
      build: () {
        when(
          () => mockUseCase(
            currentPassword: 'WrongPass',
            newPassword: 'NewPass123',
            confirmNewPassword: 'NewPass123',
          ),
        ).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'errors.invalid_password'),
        );
        return cubit;
      },
      seed: () => const ChangePasswordState(
        currentPassword: 'WrongPass',
        newPassword: 'NewPass123',
        confirmPassword: 'NewPass123',
      ),
      act: (c) => c.onIntent(const ChangePasswordSubmitted()),
      expect: () => [
        const ChangePasswordState(
          currentPassword: 'WrongPass',
          newPassword: 'NewPass123',
          confirmPassword: 'NewPass123',
          changePasswordResource: Resource.loading(),
        ),
        const ChangePasswordState(
          currentPassword: 'WrongPass',
          newPassword: 'NewPass123',
          confirmPassword: 'NewPass123',
          currentPasswordError: 'errors.invalid_password',
          changePasswordResource: Resource.error('errors.invalid_password'),
        ),
      ],
    );
  });
}
