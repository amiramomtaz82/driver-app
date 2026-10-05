import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:driver_app/features/auth/domain/models/user_model.dart';
import 'package:driver_app/features/auth/domain/repo/auth_repo.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_intents.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

const _testUser = UserModel(
  id: 'user-id',
  email: 'test@test.com',
  fullName: 'Test User',
  role: 'Driver',
  isActive: true,
);

const _successResponse = LoginResponseModel(
  token: 'abc123',
  refreshToken: 'refresh123',
  expiresIn: 900,
  user: _testUser,
);

void main() {
  late MockAuthRepo mockRepo;
  late LoginCubit cubit;

  setUp(() {
    mockRepo = MockAuthRepo();
    cubit = LoginCubit(mockRepo);
  });

  tearDown(() => cubit.close());

  group('LoginCubit ', () {
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
      'emits loading then success on LoginSubmitted  success',
      build: () {
        when(
          () => mockRepo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            rememberMe: any(named: 'rememberMe'),
          ),
        ).thenAnswer((_) async => const SuccessResponse(_successResponse));
        return cubit;
      },
      act: (c) async {
        c.onIntent(const EmailChanged('test@test.com'));
        c.onIntent(const PasswordChanged('Pass1234'));
        await Future<void>.delayed(Duration.zero);
        c.onIntent(const LoginSubmitted());
      },
      expect: () => [
        const LoginState(email: 'test@test.com'),
        const LoginState(email: 'test@test.com', password: 'Pass1234'),
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
      'emits loading then error on LoginSubmitted  failure',
      build: () {
        when(
          () => mockRepo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            rememberMe: any(named: 'rememberMe'),
          ),
        ).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Invalid credentials'),
        );
        return cubit;
      },
      act: (c) async {
        c.onIntent(const EmailChanged('test@test.com'));
        c.onIntent(const PasswordChanged('Pass1234'));
        await Future<void>.delayed(Duration.zero);
        c.onIntent(const LoginSubmitted());
      },
      expect: () => [
        const LoginState(email: 'test@test.com'),
        const LoginState(email: 'test@test.com', password: 'Pass1234'),
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
