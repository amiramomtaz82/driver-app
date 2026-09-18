import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:driver_app/features/auth/domain/repo/auth_repo.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_intents.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockRepo;
  late LoginCubit cubit;

  setUp(() {
    mockRepo = MockAuthRepo();
    cubit = LoginCubit(mockRepo);
  });

  tearDown(() => cubit.close());

  group('LoginCubit —', () {
    test('initial state is correct', () {
      expect(cubit.state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'emits updated email on EmailChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const EmailChanged('test@test.com')),
      expect: () => [
        const LoginState(email: 'test@test.com'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits updated password on PasswordChanged',
      build: () => cubit,
      act: (c) => c.onIntent(const PasswordChanged('Pass1234')),
      expect: () => [
        const LoginState(password: 'Pass1234'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'toggles rememberMe on RememberMeToggled',
      build: () => cubit,
      act: (c) => c.onIntent(const RememberMeToggled()),
      expect: () => [
        const LoginState(rememberMe: true),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits loading then success on LoginSubmitted — success',
      build: () {
        when(
          () => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')),
        ).thenAnswer(
          (_) async => SuccessResponse(const LoginResponseModel(token: 'abc123')),
        );
        return cubit;
      },
      seed: () => const LoginState(email: 'test@test.com', password: 'Pass1234'),
      act: (c) => c.onIntent(const LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'test@test.com',
          password: 'Pass1234',
          loginResource: Resource.loading(),
        ),
        isA<LoginState>().having(
          (s) => s.loginResource.isSuccess,
          'isSuccess',
          true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits loading then error on LoginSubmitted — failure',
      build: () {
        when(
          () => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')),
        ).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Invalid credentials'),
        );
        return cubit;
      },
      seed: () => const LoginState(email: 'test@test.com', password: 'Pass1234'),
      act: (c) => c.onIntent(const LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'test@test.com',
          password: 'Pass1234',
          loginResource: Resource.loading(),
        ),
        isA<LoginState>().having(
          (s) => s.loginResource.isError,
          'isError',
          true,
        ),
      ],
    );
  });
}
