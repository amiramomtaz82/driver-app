import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/domain/entities/driver_vehicle_entity.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_intents.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_state.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/profile_view.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/logout_dialog.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/logout_tile.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/profile_content_list.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/profile_error_view.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/profile_shimmer.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/settings_language_tile.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/user_info_card.dart';
import 'package:driver_app/features/profile/presentation/view/profile_view/widgets/vehicle_info_card.dart';
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
        'title': 'Profile',
        'vehicle_info': 'Vehicle Information',
        'language': 'Language',
        'logout': 'Log Out',
        'logout_confirm_title': 'Log Out',
        'logout_confirm_msg': 'Are you sure you want to log out?',
        'logout_confirm_message': 'Are you sure you want to log out?',
      },
      'common': {
        'retry': 'Retry',
        'cancel': 'Cancel',
        'logout': 'Log Out',
      }
    };
  }
}

void main() {
  late MockProfileCubit mockCubit;

  const testVehicle = DriverVehicleEntity(
    vehicleType: 'Car',
    vehicleNumber: 'XYZ 1234',
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

  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
    registerFallbackValue(const ProfileStarted());
    registerFallbackValue(const ProfileRefreshed());
    registerFallbackValue(const LogoutConfirmed());
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
              child: const ProfileView(),
            ),
          );
        },
      ),
    );
  }

  group('ProfileView Widget Tests', () {
    testWidgets('dispatches ProfileStarted on init and renders shimmer when loading',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.loading(),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      verify(() => mockCubit.onIntent(const ProfileStarted())).called(1);
      expect(find.byType(ProfileShimmer), findsOneWidget);
      expect(find.byType(ProfileContentList), findsNothing);
      expect(find.byType(ProfileErrorView), findsNothing);
    });

    testWidgets('renders ProfileErrorView on error and tapping retry dispatches ProfileRefreshed',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.error('Network connection error'),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileErrorView), findsOneWidget);
      expect(find.text('Network connection error'), findsOneWidget);

      final retryBtn = find.byType(ElevatedButton);
      expect(retryBtn, findsOneWidget);
      await tester.tap(retryBtn);

      verify(() => mockCubit.onIntent(const ProfileRefreshed())).called(1);
    });

    testWidgets('renders ProfileContentList with user info and vehicle cards when success',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileContentList), findsOneWidget);
      expect(find.byType(UserInfoCard), findsOneWidget);
      expect(find.byType(VehicleInfoCard), findsOneWidget);
      expect(find.byType(SettingsLanguageTile), findsOneWidget);
      expect(find.byType(LogoutTile), findsOneWidget);

      expect(find.text('English'), findsOneWidget);
      expect(find.text('Amira Momtaz'), findsOneWidget);
      expect(find.text('amira@example.com'), findsOneWidget);
      expect(find.text('01012345678'), findsOneWidget);
      expect(find.text('XYZ 1234'), findsOneWidget);
    });

    testWidgets('tapping logout tile opens LogoutDialog and confirming dispatches LogoutConfirmed',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      // Find and scroll to LogoutTile if needed
      final logoutTile = find.byType(LogoutTile);
      expect(logoutTile, findsOneWidget);
      await tester.ensureVisible(logoutTile);
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(LogoutDialog), findsOneWidget);

      final confirmBtn = find.descendant(
        of: find.byType(LogoutDialog),
        matching: find.byType(ElevatedButton),
      );
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);

      verify(() => mockCubit.onIntent(const LogoutConfirmed())).called(1);
    });

    testWidgets('renders Unknown in VehicleInfoCard when vehicle info is not provided',
        (tester) async {
      const profileWithoutVehicle = DriverProfileEntity(
        id: '1',
        fullName: 'Amira Momtaz',
        email: 'amira@example.com',
        phone: '01012345678',
        gender: 'Female',
        photoUrl: null,
        vehicle: null,
      );
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(profileWithoutVehicle),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.text('Unknown'), findsNWidgets(2)); // Type and Number both Unknown
    });
  });
}
