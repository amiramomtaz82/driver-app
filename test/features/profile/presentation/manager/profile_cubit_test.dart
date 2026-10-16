import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/services/image_picker_service.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_vehicle_type_use_case.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/domain/entities/driver_vehicle_entity.dart';
import 'package:driver_app/features/profile/domain/entities/update_user_profile_params.dart';
import 'package:driver_app/features/profile/domain/entities/update_vehicle_params.dart';
import 'package:driver_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/update_user_profile_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_intents.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateUserProfileUseCase extends Mock implements UpdateUserProfileUseCase {}
class MockUpdateVehicleUseCase extends Mock implements UpdateVehicleUseCase {}
class MockGetVehicleTypesUseCase extends Mock implements GetVehicleTypesUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockImagePickerService extends Mock implements ImagePickerService {}

class FakeUpdateUserProfileParams extends Fake implements UpdateUserProfileParams {}
class FakeUpdateVehicleParams extends Fake implements UpdateVehicleParams {}

void main() {
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockUpdateVehicleUseCase mockUpdateVehicleUseCase;
  late MockGetVehicleTypesUseCase mockGetVehicleTypesUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockImagePickerService mockImagePickerService;

  const testVehicle = DriverVehicleEntity(
    vehicleType: 'Car',
    vehicleNumber: 'ABC 1234',
    licensePhotoUrl: 'https://example.com/license.jpg',
  );

  const testProfile = DriverProfileEntity(
    id: 'user_1',
    fullName: 'Amira Momtaz',
    email: 'amira@example.com',
    phone: '01012345678',
    gender: 'Female',
    photoUrl: 'https://example.com/photo.jpg',
    vehicle: testVehicle,
  );

  const testVehicleTypes = [
    VehicleType(id: '1', name: 'Car'),
    VehicleType(id: '2', name: 'Motorcycle'),
  ];

  setUpAll(() {
    registerFallbackValue(FakeUpdateUserProfileParams());
    registerFallbackValue(FakeUpdateVehicleParams());
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockUpdateVehicleUseCase = MockUpdateVehicleUseCase();
    mockGetVehicleTypesUseCase = MockGetVehicleTypesUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockImagePickerService = MockImagePickerService();
  });

  ProfileCubit buildCubit() {
    return ProfileCubit(
      mockGetProfileUseCase,
      mockUpdateUserProfileUseCase,
      mockUpdateVehicleUseCase,
      mockGetVehicleTypesUseCase,
      mockLogoutUseCase,
      mockImagePickerService,
    );
  }

  group('ProfileCubit - Initial State', () {
    test('initial state matches ProfileState.initial()', () {
      final cubit = buildCubit();
      expect(cubit.state, equals(ProfileState.initial()));
      cubit.close();
    });
  });

  group('ProfileCubit - Profile Loading & Refresh', () {
    blocTest<ProfileCubit, ProfileState>(
      'ProfileStarted emits loading then success when GetProfileUseCase succeeds',
      build: () {
        when(() => mockGetProfileUseCase()).thenAnswer(
          (_) async => const SuccessResponse(testProfile),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.onIntent(const ProfileStarted()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
        ),
      ],
      verify: (_) => verify(() => mockGetProfileUseCase()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'ProfileRefreshed emits loading then error when GetProfileUseCase fails',
      build: () {
        when(() => mockGetProfileUseCase()).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Failed to load profile'),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.onIntent(const ProfileRefreshed()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.error('Failed to load profile'),
        ),
      ],
      verify: (_) => verify(() => mockGetProfileUseCase()).called(1),
    );
  });

  group('ProfileCubit - Logout', () {
    blocTest<ProfileCubit, ProfileState>(
      'LogoutConfirmed emits loading then initial and dispatches navigation event',
      build: () {
        when(() => mockLogoutUseCase()).thenAnswer(
          (_) async => const SuccessResponse(null),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.onIntent(const LogoutConfirmed()),
      expect: () => [
        ProfileState.initial().copyWith(
          logoutResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          logoutResource: const Resource.initial(),
        ),
      ],
      verify: (_) => verify(() => mockLogoutUseCase()).called(1),
    );
  });

  group('ProfileCubit - User Edit Form', () {
    blocTest<ProfileCubit, ProfileState>(
      'InitUserEditForm populates user fields from current profile',
      build: () => buildCubit(),
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
      ),
      act: (cubit) => cubit.onIntent(const InitUserEditForm()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editFirstName: testProfile.firstName,
          editLastName: testProfile.lastName,
          editEmail: testProfile.email,
          editPhone: testProfile.phone,
          editGender: testProfile.gender,
          editPhotoPath: null,
          updateUserResource: const Resource.initial(),
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'form field intents update their corresponding state values',
      build: () => buildCubit(),
      act: (cubit) {
        cubit.onIntent(const FirstNameChanged('Sara'));
        cubit.onIntent(const LastNameChanged('Ahmed'));
        cubit.onIntent(const PhoneChanged('01123456789'));
        cubit.onIntent(const GenderChanged('Female'));
      },
      expect: () => [
        ProfileState.initial().copyWith(editFirstName: 'Sara'),
        ProfileState.initial().copyWith(editFirstName: 'Sara', editLastName: 'Ahmed'),
        ProfileState.initial().copyWith(
          editFirstName: 'Sara',
          editLastName: 'Ahmed',
          editPhone: '01123456789',
        ),
        ProfileState.initial().copyWith(
          editFirstName: 'Sara',
          editLastName: 'Ahmed',
          editPhone: '01123456789',
          editGender: 'Female',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'PickUserPhotoIntent picks photo and updates editPhotoPath',
      build: () {
        when(() => mockImagePickerService.pickImageFromGallery()).thenAnswer(
          (_) async => '/data/user/0/cache/photo.jpg',
        );
        return buildCubit();
      },
      act: (cubit) => cubit.onIntent(const PickUserPhotoIntent(ImageSource.gallery)),
      expect: () => [
        ProfileState.initial().copyWith(editPhotoPath: '/data/user/0/cache/photo.jpg'),
      ],
      verify: (_) => verify(() => mockImagePickerService.pickImageFromGallery()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitUserEdit does nothing when form is not valid',
      build: () => buildCubit(),
      act: (cubit) => cubit.onIntent(const SubmitUserEdit()),
      expect: () => [],
      verify: (_) => verifyNever(() => mockUpdateUserProfileUseCase(any())),
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitUserEdit succeeds, updates profile entity, and emits success',
      build: () {
        when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
          (_) async => const SuccessResponse(testProfile),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: 'UpdatedName',
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      ),
      act: (cubit) => cubit.onIntent(const SubmitUserEdit()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editFirstName: 'UpdatedName',
          editLastName: testProfile.lastName,
          editEmail: testProfile.email,
          editPhone: testProfile.phone,
          editGender: testProfile.gender,
          updateUserResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: Resource.success(
            testProfile.copyWith(fullName: 'UpdatedName ${testProfile.lastName}'),
          ),
          editFirstName: 'UpdatedName',
          editLastName: testProfile.lastName,
          editEmail: testProfile.email,
          editPhone: testProfile.phone,
          editGender: testProfile.gender,
          updateUserResource: const Resource.success(null),
        ),
      ],
      verify: (_) => verify(() => mockUpdateUserProfileUseCase(any())).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitUserEdit handles error and emits error resource',
      build: () {
        when(() => mockUpdateUserProfileUseCase(any())).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Update failed'),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: 'UpdatedName',
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      ),
      act: (cubit) => cubit.onIntent(const SubmitUserEdit()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editFirstName: 'UpdatedName',
          editLastName: testProfile.lastName,
          editEmail: testProfile.email,
          editPhone: testProfile.phone,
          editGender: testProfile.gender,
          updateUserResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editFirstName: 'UpdatedName',
          editLastName: testProfile.lastName,
          editEmail: testProfile.email,
          editPhone: testProfile.phone,
          editGender: testProfile.gender,
          updateUserResource: const Resource.error('Update failed'),
        ),
      ],
      verify: (_) => verify(() => mockUpdateUserProfileUseCase(any())).called(1),
    );
  });

  group('ProfileCubit - Vehicle Edit Form', () {
    blocTest<ProfileCubit, ProfileState>(
      'InitVehicleEditForm loads vehicle types and matches existing type',
      build: () {
        when(() => mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => const SuccessResponse(testVehicleTypes),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
      ),
      act: (cubit) => cubit.onIntent(const InitVehicleEditForm()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editVehicleNumber: testVehicle.vehicleNumber,
          editLicensePath: testVehicle.licensePhotoUrl,
          vehicleTypesResource: const Resource.loading(),
          updateVehicleResource: const Resource.initial(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editVehicleNumber: testVehicle.vehicleNumber,
          editLicensePath: testVehicle.licensePhotoUrl,
          vehicleTypesResource: const Resource.success(testVehicleTypes),
          selectedVehicleType: testVehicleTypes.first,
          updateVehicleResource: const Resource.initial(),
        ),
      ],
      verify: (_) => verify(() => mockGetVehicleTypesUseCase()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'InitVehicleEditForm emits error resource and snackbar when GetVehicleTypesUseCase fails',
      build: () {
        when(() => mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Network error'),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
      ),
      act: (cubit) => cubit.onIntent(const InitVehicleEditForm()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editVehicleNumber: testVehicle.vehicleNumber,
          editLicensePath: testVehicle.licensePhotoUrl,
          vehicleTypesResource: const Resource.loading(),
          updateVehicleResource: const Resource.initial(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          editVehicleNumber: testVehicle.vehicleNumber,
          editLicensePath: testVehicle.licensePhotoUrl,
          vehicleTypesResource: const Resource.error('Network error'),
          updateVehicleResource: const Resource.initial(),
        ),
      ],
      verify: (_) => verify(() => mockGetVehicleTypesUseCase()).called(1),
    );

    test('InitVehicleEditForm emits error snackbar event when GetVehicleTypesUseCase fails', () async {
      when(() => mockGetVehicleTypesUseCase()).thenAnswer(
        (_) async => ErrorResponse(errMessage: 'Network error'),
      );
      final cubit = buildCubit();
      expectLater(
        cubit.eventStream,
        emits(
          isA<ShowSnackBarEvent>()
              .having((e) => e.message, 'message', 'Network error')
              .having((e) => e.isError, 'isError', true),
        ),
      );
      cubit.onIntent(const InitVehicleEditForm());
    });

    blocTest<ProfileCubit, ProfileState>(
      'Vehicle field intents update selectedVehicleType and editVehicleNumber',
      build: () => buildCubit(),
      act: (cubit) {
        cubit.onIntent(const VehicleTypeSelected(VehicleType(id: '2', name: 'Motorcycle')));
        cubit.onIntent(const VehicleNumberChanged('XYZ 9999'));
      },
      expect: () => [
        ProfileState.initial().copyWith(
          selectedVehicleType: const VehicleType(id: '2', name: 'Motorcycle'),
        ),
        ProfileState.initial().copyWith(
          selectedVehicleType: const VehicleType(id: '2', name: 'Motorcycle'),
          editVehicleNumber: 'XYZ 9999',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'PickVehicleLicenseIntent picks image and updates editLicensePath',
      build: () {
        when(() => mockImagePickerService.pickImageFromCamera()).thenAnswer(
          (_) async => '/data/user/0/cache/license.jpg',
        );
        return buildCubit();
      },
      act: (cubit) => cubit.onIntent(const PickVehicleLicenseIntent(ImageSource.camera)),
      expect: () => [
        ProfileState.initial().copyWith(editLicensePath: '/data/user/0/cache/license.jpg'),
      ],
      verify: (_) => verify(() => mockImagePickerService.pickImageFromCamera()).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitVehicleEdit succeeds and updates vehicle on success',
      build: () {
        when(() => mockUpdateVehicleUseCase(any())).thenAnswer(
          (_) async => const SuccessResponse(null),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
        editVehicleNumber: 'NEW 5678',
        editLicensePath: '/local/license.png',
      ),
      act: (cubit) => cubit.onIntent(const SubmitVehicleEdit()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
          editVehicleNumber: 'NEW 5678',
          editLicensePath: '/local/license.png',
          updateVehicleResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: Resource.success(
            testProfile.copyWith(
              vehicle: const DriverVehicleEntity(
                vehicleType: 'Car',
                vehicleNumber: 'NEW 5678',
                licensePhotoUrl: '/local/license.png',
              ),
            ),
          ),
          selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
          editVehicleNumber: 'NEW 5678',
          editLicensePath: '/local/license.png',
          updateVehicleResource: const Resource.success(null),
        ),
      ],
      verify: (_) => verify(() => mockUpdateVehicleUseCase(any())).called(1),
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitVehicleEdit emits error when UpdateVehicleUseCase fails',
      build: () {
        when(() => mockUpdateVehicleUseCase(any())).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Vehicle update failed'),
        );
        return buildCubit();
      },
      seed: () => ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
        editVehicleNumber: 'NEW 5678',
      ),
      act: (cubit) => cubit.onIntent(const SubmitVehicleEdit()),
      expect: () => [
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
          editVehicleNumber: 'NEW 5678',
          updateVehicleResource: const Resource.loading(),
        ),
        ProfileState.initial().copyWith(
          profileResource: const Resource.success(testProfile),
          selectedVehicleType: const VehicleType(id: '1', name: 'Car'),
          editVehicleNumber: 'NEW 5678',
          updateVehicleResource: const Resource.error('Vehicle update failed'),
        ),
      ],
      verify: (_) => verify(() => mockUpdateVehicleUseCase(any())).called(1),
    );
  });
}
