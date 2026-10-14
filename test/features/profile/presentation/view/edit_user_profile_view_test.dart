import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_intents.dart';
import 'package:driver_app/features/profile/presentation/manager/profile_state.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/edit_user_profile_view.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/edit_user_avatar_picker.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/gender_selector.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/name_fields_row.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/update_user_profile_button.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/user_email_field.dart';
import 'package:driver_app/features/profile/presentation/view/edit_profile/widgets/user_phone_field.dart';
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
        'edit_profile': 'Edit Profile',
        'first_name': 'First Name',
        'last_name': 'Last Name',
        'email': 'Email',
        'phone': 'Phone Number',
        'update_profile': 'Update Profile',
      },
      'auth': {
        'email_label': 'Email Address',
      },
      'common': {
        'update': 'Update',
        'gender': 'Gender',
        'gender_female': 'Female',
        'gender_male': 'Male',
      }
    };
  }
}

void main() {
  late MockProfileCubit mockCubit;

  const testProfile = DriverProfileEntity(
    id: '1',
    fullName: 'Amira Momtaz',
    email: 'amira@example.com',
    phone: '01012345678',
    gender: 'Female',
    photoUrl: null,
  );

  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
    registerFallbackValue(const InitUserEditForm());
    registerFallbackValue(const FirstNameChanged(''));
    registerFallbackValue(const LastNameChanged(''));
    registerFallbackValue(const PhoneChanged(''));
    registerFallbackValue(const GenderChanged(''));
    registerFallbackValue(const SubmitUserEdit());
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
              child: const EditUserProfileView(),
            ),
          );
        },
      ),
    );
  }

  group('EditUserProfileView Widget Tests', () {
    testWidgets('dispatches InitUserEditForm on init and renders all form widgets',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: testProfile.firstName,
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      verify(() => mockCubit.onIntent(const InitUserEditForm())).called(1);

      expect(find.byType(EditUserAvatarPicker), findsOneWidget);
      expect(find.byType(NameFieldsRow), findsOneWidget);
      expect(find.byType(UserEmailField), findsOneWidget);
      expect(find.byType(UserPhoneField), findsOneWidget);
      expect(find.byType(GenderSelector), findsOneWidget);
      expect(find.byType(UpdateUserProfileButton), findsOneWidget);

      expect(find.text('amira@example.com'), findsOneWidget);
    });

    testWidgets('typing in fields dispatches FirstNameChanged, LastNameChanged, and PhoneChanged',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: testProfile.firstName,
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      // Find text fields inside NameFieldsRow
      final nameFields = find.descendant(
        of: find.byType(NameFieldsRow),
        matching: find.byType(TextFormField),
      );
      expect(nameFields, findsNWidgets(2));

      // Enter text into first name field
      await tester.enterText(nameFields.at(0), 'Nour');
      verify(() => mockCubit.onIntent(const FirstNameChanged('Nour'))).called(1);

      // Enter text into last name field
      await tester.enterText(nameFields.at(1), 'Ali');
      verify(() => mockCubit.onIntent(const LastNameChanged('Ali'))).called(1);

      // Enter text into phone field
      final phoneField = find.descendant(
        of: find.byType(UserPhoneField),
        matching: find.byType(TextFormField),
      );
      expect(phoneField, findsOneWidget);
      await tester.enterText(phoneField, '01299998888');
      verify(() => mockCubit.onIntent(const PhoneChanged('01299998888'))).called(1);
    });

    testWidgets('changing gender radio selection dispatches GenderChanged',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: testProfile.firstName,
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: 'Female',
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final maleRadio = find.byType(Radio<String>).last;
      await tester.tap(maleRadio);

      verify(() => mockCubit.onIntent(const GenderChanged('Male'))).called(1);
    });

    testWidgets('update button is disabled when form is not valid',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: testProfile.firstName, // unchanged -> hasUserEditChanged = false
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(UpdateUserProfileButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('update button is enabled when form is valid and tapping it dispatches SubmitUserEdit',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: 'ChangedName', // Changed!
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      final buttonFinder = find.descendant(
        of: find.byType(UpdateUserProfileButton),
        matching: find.byType(ElevatedButton),
      );
      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.onPressed, isNotNull);

      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      verify(() => mockCubit.onIntent(const SubmitUserEdit())).called(1);
    });

    testWidgets('update button shows progress indicator when loading',
        (tester) async {
      final state = ProfileState.initial().copyWith(
        profileResource: const Resource.success(testProfile),
        editFirstName: 'ChangedName',
        editLastName: testProfile.lastName,
        editEmail: testProfile.email,
        editPhone: testProfile.phone,
        editGender: testProfile.gender,
        updateUserResource: const Resource.loading(),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pump(); // Pump frame without pumpAndSettle to check progress indicator

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
