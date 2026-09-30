import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/core/services/image_picker_service.dart';
import 'package:driver_app/features/auth/domain/entities/country.dart';
import 'package:driver_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_countries_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_vehicle_type_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:driver_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:driver_app/features/auth/presentation/register/manager/register_intents.dart';
import 'package:driver_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:driver_app/features/auth/presentation/register/models/register_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockGetCountriesUseCase extends Mock implements GetCountriesUseCase {}
class MockGetVehicleTypesUseCase extends Mock implements GetVehicleTypesUseCase {}
class MockImagePickerService extends Mock implements ImagePickerService {}
class FakeRegisterForm extends Fake implements RegisterEntity {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetCountriesUseCase mockGetCountriesUseCase;
  late MockGetVehicleTypesUseCase mockGetVehicleTypesUseCase;
  late MockImagePickerService mockImagePickerService;

  setUpAll(() {
    registerFallbackValue(FakeRegisterForm());
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    mockGetVehicleTypesUseCase = MockGetVehicleTypesUseCase();
    mockImagePickerService = MockImagePickerService();

    when(() => mockGetCountriesUseCase()).thenAnswer(
      (_) async => const SuccessResponse<List<Country>>([]),
    );
    when(() => mockGetVehicleTypesUseCase()).thenAnswer(
      (_) async => const SuccessResponse<List<VehicleType>>([]),
    );
  });

  RegisterCubit buildCubit() {
    return RegisterCubit(
      mockRegisterUseCase,
      mockGetCountriesUseCase,
      mockGetVehicleTypesUseCase,
      mockImagePickerService,
    );
  }

  group('RegisterCubit - Dropdown Data Loading', () {
    const countries = [Country(id: 'eg', name: 'Egypt', flag: '🇪🇬', code: '+20')];
    const vehicleTypes = [VehicleType(id: 'car', name: 'Car')];

    blocTest<RegisterCubit, RegisterState>(
      'loads countries and vehicle types successfully when LoadDropdownDataIntent is dispatched',
      setUp: () {
        when(() => mockGetCountriesUseCase()).thenAnswer(
          (_) async => const SuccessResponse(countries),
        );
        when(() => mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => const SuccessResponse(vehicleTypes),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.onIntent(const LoadDropdownDataIntent()),
      expect: () => [
        predicate<RegisterState>((s) =>
            s.countriesResource.isLoading && s.vehicleTypesResource.isLoading),
        predicate<RegisterState>((s) =>
            s.countriesResource.isSuccess &&
            s.countriesResource.data == countries &&
            s.selectedCountry == countries.first &&
            s.vehicleTypesResource.isSuccess &&
            s.vehicleTypesResource.data == vehicleTypes &&
            s.selectedVehicleType == vehicleTypes.first),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits error when countries or vehicle types fetch fails',
      setUp: () {
        when(() => mockGetCountriesUseCase()).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Failed to fetch countries'),
        );
        when(() => mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Failed to fetch vehicles'),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.onIntent(const LoadDropdownDataIntent()),
      expect: () => [
        predicate<RegisterState>((s) =>
            s.countriesResource.isLoading && s.vehicleTypesResource.isLoading),
        predicate<RegisterState>((s) =>
            s.countriesResource.isError &&
            s.countriesResource.errorMessage == 'Failed to fetch countries' &&
            s.vehicleTypesResource.isError &&
            s.vehicleTypesResource.errorMessage == 'Failed to fetch vehicles'),
      ],
    );
  });

  group('RegisterCubit - Form Field Intents', () {
    late RegisterCubit registerCubit;
    const country = Country(id: 'sa', name: 'Saudi Arabia', flag: '🇸🇦', code: '+966');
    const vehicleType = VehicleType(id: 'motorcycle', name: 'Motorcycle');

    setUp(() {
      registerCubit = buildCubit();
    });

    tearDown(() {
      registerCubit.close();
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits state with selected country when SelectCountryIntent is dispatched',
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const SelectCountryIntent(country)),
      expect: () => [
        predicate<RegisterState>((s) => s.selectedCountry == country),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits state with selected vehicle type when SelectVehicleTypeIntent is dispatched',
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const SelectVehicleTypeIntent(vehicleType)),
      expect: () => [
        predicate<RegisterState>((s) => s.selectedVehicleType == vehicleType),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits state with selected gender when SelectGenderIntent is dispatched',
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const SelectGenderIntent('female')),
      expect: () => [
        predicate<RegisterState>((s) => s.gender == 'female'),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles password visibility when TogglePasswordVisibilityIntent is dispatched',
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const TogglePasswordVisibilityIntent()),
      expect: () => [
        predicate<RegisterState>((s) => s.isPasswordHidden == false),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles confirm password visibility when ToggleConfirmPasswordVisibilityIntent is dispatched',
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const ToggleConfirmPasswordVisibilityIntent()),
      expect: () => [
        predicate<RegisterState>((s) => s.isConfirmPasswordHidden == false),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'updates licensePhotoPath when PickLicensePhotoIntent is dispatched',
      setUp: () {
        when(() => mockImagePickerService.pickImageFromGallery())
            .thenAnswer((_) async => '/cache/license.png');
      },
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const PickLicensePhotoIntent(ImageSource.gallery)),
      expect: () => [
        predicate<RegisterState>((s) => s.licensePhotoPath == '/cache/license.png'),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'updates idImagePath when PickIdImageIntent is dispatched',
      setUp: () {
        when(() => mockImagePickerService.pickImageFromGallery())
            .thenAnswer((_) async => '/cache/id.png');
      },
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const PickIdImageIntent(ImageSource.gallery)),
      expect: () => [
        predicate<RegisterState>((s) => s.idImagePath == '/cache/id.png'),
      ],
    );
  });

  group('RegisterCubit - Submit Registration', () {
    late RegisterCubit registerCubit;
    const form = RegisterEntity(
      firstName: 'Omar',
      lastName: 'Khaled',
      email: 'omar@example.com',
      phone: '01234567890',
      password: 'Password123!',
      gender: 'male',
      vehicleType: 'car',
      vehicleNumber: '789 GHI',
      nationalId: '12345678901234',
      vehicleLicense: '/path/license.png',
      idImage: '/path/id.png',
    );

    setUp(() {
      registerCubit = buildCubit();
    });

    tearDown(() {
      registerCubit.close();
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits loading then success when registration succeeds',
      setUp: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
          (_) async => const SuccessResponse(
            RegisterEntityResponse(success: true, message: 'Created'),
          ),
        );
      },
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const SubmitRegisterIntent(form)),
      expect: () => [
        predicate<RegisterState>((s) => s.registerResource.isLoading),
        predicate<RegisterState>((s) =>
            s.registerResource.isSuccess && s.registerResource.data?.success == true),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(form)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits loading then error when registration fails',
      setUp: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
          (_) async => ErrorResponse(errMessage: 'Email already exists'),
        );
      },
      build: () => registerCubit,
      act: (cubit) => cubit.onIntent(const SubmitRegisterIntent(form)),
      expect: () => [
        predicate<RegisterState>((s) => s.registerResource.isLoading),
        predicate<RegisterState>((s) =>
            s.registerResource.isError &&
            s.registerResource.errorMessage == 'Email already exists'),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(form)).called(1);
      },
    );
  });
}
