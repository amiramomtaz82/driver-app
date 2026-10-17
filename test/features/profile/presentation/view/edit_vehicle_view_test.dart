import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/domain/entities/driver_vehicle_entity.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_intents.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_state.dart';
import 'package:driver_app/features/profile/presentation/view/edit_vehicle/edit_vehicle_view.dart';
import 'package:driver_app/features/profile/presentation/view/edit_vehicle/widgets/update_vehicle_button.dart';
import 'package:driver_app/features/profile/presentation/view/edit_vehicle/widgets/vehicle_license_upload.dart';
import 'package:driver_app/features/profile/presentation/view/edit_vehicle/widgets/vehicle_number_field.dart';
import 'package:driver_app/features/profile/presentation/view/edit_vehicle/widgets/vehicle_type_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'profile': {
        'edit_profile': 'Edit Vehicle',
        'select_vehicle_type': 'Select vehicle type',
        'loading_vehicle_types': 'Loading vehicle types...',
      },
      'apply': {
        'vehicle_type_label': 'Vehicle Type',
        'vehicle_number_label': 'Vehicle Plate Number',
        'vehicle_license_label': 'Vehicle License',
        'vehicle_license_hint': 'Upload License Document',
      },
      'common': {
        'update': 'Update',
      }
    };
  }
}

void main() {
  late MockProfileCubit mockCubit;

  const testVehicle = DriverVehicleEntity(
    vehicleType: 'Car',
    vehicleNumber: 'ABC 1234',
    licensePhotoUrl: null,
  );

  const testProfile = DriverProfileEntity(
    id: '1',
    fullName: 'Amira Momtaz',
    email: 'amira@example.com',
    phone: '01012345678',
    gender: 'Female',
    photoUrl: null,
    vehicle: testVehicle,
  );

  const testVehicleTypes = [
    VehicleType(id: '1', name: 'Car'),
    VehicleType(id: '2', name: 'Motorcycle'),
  ];

  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
    registerFallbackValue(const InitVehicleEditForm());
    registerFallbackValue(const VehicleTypeSelected(VehicleType(id: '1', name: 'Car')));
    registerFallbackValue(const VehicleNumberChanged(''));
    registerFallbackValue(const SubmitVehicleEdit());
  });

  setUp(() {
    mockCubit = MockProfileCubit();
    when(() => mockCubit.stream).thenAnswer((_) => const Stream<ProfileState>.empty());
    when(() => mockCubit.eventStream).thenAnswer((_) => const Stream<UiEvent>.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});
    when(() => mockCubit.onIntent(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest(ProfileState state) {
    when(() => mockCubit.state).thenReturn(state);
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
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: BlocProvider<ProfileCubit>.value(
              value: mockCubit,
              child: const EditVehicleView(),
            ),
          );
        },
      ),
    );
  }

  group('EditVehicleView Widget Tests', () {
    testWidgets('dispatches InitVehicleEditForm on init and renders all vehicle form widgets',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: testVehicle.vehicleNumber,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      verify(() => mockCubit.onIntent(const InitVehicleEditForm())).called(1);

      expect(find.byType(VehicleTypeDropdownField), findsOneWidget);
      expect(find.byType(VehicleNumberField), findsOneWidget);
      expect(find.byType(VehicleLicenseUploadTile), findsOneWidget);
      expect(find.byType(UpdateVehicleButton), findsOneWidget);

      expect(find.text(testVehicle.vehicleNumber), findsOneWidget);
    });

    testWidgets('shows loading spinner inside dropdown while vehicle types are loading',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.loading(),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pump(); // Single pump to avoid pumpAndSettle timeout on spinner

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading vehicle types...'), findsOneWidget);
    });

    testWidgets('typing in plate number field dispatches VehicleNumberChanged',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: testVehicle.vehicleNumber,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final numberField = find.descendant(
        of: find.byType(VehicleNumberField),
        matching: find.byType(TextFormField),
      );
      expect(numberField, findsOneWidget);

      await tester.enterText(numberField, 'XYZ 9999');
      verify(() => mockCubit.onIntent(const VehicleNumberChanged('XYZ 9999'))).called(1);
    });

    testWidgets('selecting a vehicle type from dropdown dispatches VehicleTypeSelected',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: testVehicle.vehicleNumber,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      // Open dropdown
      final dropdown = find.byType(DropdownButtonFormField<VehicleType>);
      expect(dropdown, findsOneWidget);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select motorcycle
      final motorcycleItem = find.text('Motorcycle').last;
      await tester.tap(motorcycleItem);
      await tester.pumpAndSettle();

      verify(() => mockCubit.onIntent(
        const VehicleTypeSelected(VehicleType(id: '2', name: 'Motorcycle')),
      )).called(1);
    });

    testWidgets('update button is disabled when vehicle number is empty',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: '', // Empty -> isVehicleEditValid = false
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(UpdateVehicleButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('update button is enabled when form is valid and tapping it dispatches SubmitVehicleEdit',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: 'ABC 1234',
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final buttonFinder = find.descendant(
        of: find.byType(UpdateVehicleButton),
        matching: find.byType(ElevatedButton),
      );
      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.onPressed, isNotNull);

      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      verify(() => mockCubit.onIntent(const SubmitVehicleEdit())).called(1);
    });

    testWidgets('update button shows progress indicator when loading',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        vehicleTypesResource: const Resource.success(testVehicleTypes),
        selectedVehicleType: testVehicleTypes.first,
        editVehicleNumber: 'ABC 1234',
        updateVehicleResource: const Resource.loading(),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
