import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/di/di.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/core/services/image_picker_service.dart';
import 'package:driver_app/features/auth/domain/entities/country.dart';
import 'package:driver_app/features/auth/domain/entities/register_entity.dart';
import 'package:driver_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_countries_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_vehicle_type_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:driver_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:driver_app/features/auth/presentation/register/view/register_view.dart';
import 'package:driver_app/features/auth/presentation/register/view/widgets/document_uploade_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockGetCountriesUseCase extends Mock implements GetCountriesUseCase {}
class MockGetVehicleTypesUseCase extends Mock implements GetVehicleTypesUseCase {}
class MockImagePickerService extends Mock implements ImagePickerService {}
class FakeRegisterEntity extends Fake implements RegisterEntity {}

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'apply': {
        'title': 'Application Submission',
        'welcome_header': 'Welcome!',
        'welcome_sub': 'Join our team',
        'country_label': 'Country',
        'first_name_label': 'Legal First Name',
        'first_name_hint': 'Enter your legal first name',
        'second_name_label': 'Legal Last Name',
        'second_name_hint': 'Enter your legal last name',
        'vehicle_type_label': 'Vehicle Type',
        'vehicle_number_label': 'Vehicle Plate Number',
        'vehicle_number_hint': 'Enter vehicle plate number',
        'vehicle_license_label': 'Vehicle Registration',
        'vehicle_license_hint': 'Upload registration document',
        'phone_label': 'Phone Number',
        'phone_hint': 'Enter your phone number',
        'id_number_label': 'National ID Number',
        'id_number_hint': 'Enter your national ID number',
        'id_image_label': 'National ID Photo',
        'id_image_hint': 'Upload national ID photo',
        'apply_confirm_password_label': 'Confirm Password',
        'apply_confirm_password_hint': 'Confirm your password',
        'confirm_password_label': 'Confirm Password',
        'confirm_password_hint': 'Confirm your password',
      },
      'auth': {
        'email_label': 'Email',
        'email_hint': 'Enter your email',
        'password_label': 'Password',
        'password_hint': 'Enter your password',
      },
      'common': {
        'continue': 'Continue',
        'gender': 'Gender',
        'female': 'Female',
        'male': 'Male',
        'login': 'Log In',
      },
      'errors': {
        'validation': {
          'name_required': 'Name is required',
          'name_too_short': 'Name is too short',
          'email_required': 'Email is required',
          'email_invalid': 'Invalid email address',
          'password_required': 'Password is required',
          'password_too_short': 'Password is too short',
          'confirm_password_required': 'Confirm password is required',
          'passwords_do_not_match': 'Passwords do not match',
          'phone_required': 'Phone is required',
          'phone_invalid': 'Invalid phone number',
        }
      }
    };
  }
}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetCountriesUseCase mockGetCountriesUseCase;
  late MockGetVehicleTypesUseCase mockGetVehicleTypesUseCase;
  late MockImagePickerService mockImagePickerService;

  const testCountries = [
    Country(id: 'eg', name: 'Egypt', flag: '🇪🇬', code: '+20'),
  ];
  const testVehicleTypes = [
    VehicleType(id: 'car', name: 'Car'),
  ];

  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
    registerFallbackValue(FakeRegisterEntity());
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    mockGetVehicleTypesUseCase = MockGetVehicleTypesUseCase();
    mockImagePickerService = MockImagePickerService();

    when(() => mockGetCountriesUseCase()).thenAnswer(
      (_) async => const SuccessResponse<List<Country>>(testCountries),
    );

    when(() => mockGetVehicleTypesUseCase()).thenAnswer(
      (_) async => const SuccessResponse<List<VehicleType>>(testVehicleTypes),
    );

    when(() => mockImagePickerService.pickImageFromCamera())
        .thenAnswer((_) async => null);

    when(() => mockImagePickerService.pickImageFromGallery())
        .thenAnswer((_) async => null);

    if (getIt.isRegistered<RegisterCubit>()) {
      getIt.unregister<RegisterCubit>();
    }

    getIt.registerFactory<RegisterCubit>(() => RegisterCubit(
      mockRegisterUseCase,
      mockGetCountriesUseCase,
      mockGetVehicleTypesUseCase,
      mockImagePickerService,
    ));
  });

  tearDown(() {
    if (getIt.isRegistered<RegisterCubit>()) {
      getIt.unregister<RegisterCubit>();
    }
  });

  Widget buildTestWidget({RegisterCubit? customCubit}) {
    final router = GoRouter(
      initialLocation: AppRoutes.register,
      routes: [
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) {
            if (customCubit != null) {
              return BlocProvider<RegisterCubit>.value(
                value: customCubit,
                child: const RegisterView(),
              );
            }
            return BlocProvider<RegisterCubit>(
              create: (_) => getIt<RegisterCubit>(),
              child: const RegisterView(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.registrationSuccess,
          builder: (context, state) => const Scaffold(
            body: Text('Registration Success Screen'),
          ),
        ),
      ],
    );

    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      assetLoader: const TestAssetLoader(),
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  group('RegisterView Core Rendering', () {
    testWidgets('renders all core form fields correctly', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Application Submission'), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('Legal First Name'), findsOneWidget);
      expect(find.text('Legal Last Name'), findsOneWidget);
      expect(find.text('Vehicle Plate Number'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('National ID Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Vehicle Registration'), findsOneWidget);
      expect(find.text('National ID Photo'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });

  group('RegisterView Form Validations', () {
    testWidgets('shows validation errors when pressing Continue on empty form', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsNWidgets(2));
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Phone is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Required'), findsNWidgets(2));
    });

    testWidgets('shows invalid email validation error on malformed email', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.ensureVisible(emailField);
      await tester.enterText(emailField, 'not-an-email');

      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('shows password mismatch error when confirm password differs', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final confirmField = find.widgetWithText(TextFormField, 'Confirm Password');

      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, 'Password123!');
      await tester.enterText(confirmField, 'Different123!');

      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });

  group('RegisterView User Interactions', () {
    testWidgets('allows user to select female and male gender options', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final femaleRadio = find.byWidgetPredicate((w) => w is Radio<String> && w.value == 'female');
      final maleRadio = find.byWidgetPredicate((w) => w is Radio<String> && w.value == 'male');

      await tester.ensureVisible(femaleRadio);
      expect(femaleRadio, findsOneWidget);
      expect(maleRadio, findsOneWidget);

      await tester.tap(femaleRadio);
      await tester.pumpAndSettle();

      await tester.tap(maleRadio);
      await tester.pumpAndSettle();
    });

    testWidgets('opens bottom sheet when tapping vehicle license upload tile', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final licenseTile = find.widgetWithText(DocumentUploadTile, 'Vehicle Registration');
      await tester.ensureVisible(licenseTile);
      await tester.tap(licenseTile);
      await tester.pumpAndSettle();

      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);

      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();

      expect(find.text('Camera'), findsNothing);
    });

    testWidgets('opens bottom sheet when tapping national ID photo upload tile', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final idTile = find.widgetWithText(DocumentUploadTile, 'National ID Photo');
      await tester.ensureVisible(idTile);
      await tester.tap(idTile);
      await tester.pumpAndSettle();

      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      expect(find.text('Gallery'), findsNothing);
    });
  });

  group('RegisterView State Reactivity', () {
    testWidgets('shows loading spinner when registerResource is loading', (tester) async {
      configureViewport(tester);
      final cubit = RegisterCubit(
        mockRegisterUseCase,
        mockGetCountriesUseCase,
        mockGetVehicleTypesUseCase,
        mockImagePickerService,
      );

      await tester.pumpWidget(buildTestWidget(customCubit: cubit));
      await tester.pumpAndSettle();

      cubit.emit(cubit.state.copyWith(
        registerResource: const Resource.loading(),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator, skipOffstage: false), findsOneWidget);
    });

    testWidgets('dispatches SubmitRegisterIntent when valid form is submitted', (tester) async {
      configureViewport(tester);
      when(() => mockRegisterUseCase(any())).thenAnswer(
        (_) async => const SuccessResponse(
          RegisterEntityResponse(success: true, message: 'Created'),
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Legal First Name'), 'Ahmed');
      await tester.enterText(find.widgetWithText(TextFormField, 'Legal Last Name'), 'Hassan');
      await tester.enterText(find.widgetWithText(TextFormField, 'Vehicle Plate Number'), '123 ABC');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'ahmed@test.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '01012345678');
      await tester.enterText(find.widgetWithText(TextFormField, 'National ID Number'), '12345678901234');

      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final confirmField = find.widgetWithText(TextFormField, 'Confirm Password');

      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, 'Password123!');
      await tester.enterText(confirmField, 'Password123!');

      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      verify(() => mockRegisterUseCase(any())).called(1);
    });
  });
}
