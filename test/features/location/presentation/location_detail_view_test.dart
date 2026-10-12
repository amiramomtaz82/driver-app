import 'dart:async';

import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/constants/map_constants.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_cubit.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:driver_app/features/location/presentation/location_detail/view/location_detail_view.dart';
import 'package:driver_app/features/location/presentation/widgets/location_address_card.dart';
import 'package:driver_app/features/location/presentation/widgets/location_map_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationDetailCubit extends Mock implements LocationDetailCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoadLocationDetail());
  });

  late MockLocationDetailCubit mockCubit;
  late StreamController<LocationDetailState> stateController;
  late StreamController<UiEvent> eventController;

  const storeInfo = LocationInfo(
    name: 'Flowery Store',
    address: 'Sheikh Zayed, Giza',
    coordinates: LatLng(30.0131, 31.2089),
    phone: '01012345678',
  );

  const userInfo = LocationInfo(
    name: 'Nour Mohamed',
    address: 'Downtown, Cairo',
    coordinates: LatLng(30.0444, 31.2357),
    phone: '01198765432',
  );

  const defaultState = LocationDetailState(
    type: LocationDetailType.pickup,
    primaryInfo: storeInfo,
    secondaryInfo: userInfo,
  );

  setUp(() {
    mockCubit = MockLocationDetailCubit();
    stateController = StreamController<LocationDetailState>.broadcast();
    eventController = StreamController<UiEvent>.broadcast();

    when(() => mockCubit.state).thenReturn(defaultState);
    when(() => mockCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockCubit.eventStream).thenAnswer((_) => eventController.stream);
    when(() => mockCubit.onIntent(any())).thenReturn(null);
    when(() => mockCubit.close()).thenAnswer((_) async {});

    final getIt = GetIt.instance;
    if (getIt.isRegistered<LocationDetailCubit>()) {
      getIt.unregister<LocationDetailCubit>();
    }
    getIt.registerFactoryParam<LocationDetailCubit, LocationDetailState, void>(
      (param1, _) => mockCubit,
    );
  });

  tearDown(() {
    stateController.close();
    eventController.close();
    GetIt.instance.reset();
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(home: child);
  }

  group('LocationDetailView Widget Tests —', () {
    testWidgets('shows loading placeholder when driver location is null', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          const LocationDetailView.pickup(
            pickupInfo: storeInfo,
            userInfo: userInfo,
          ),
        ),
      );
      await tester.pump();

      expect(find.text(MapConstants.gettingLocation), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error placeholder when driver location has error', (tester) async {
      when(() => mockCubit.state).thenReturn(
        defaultState.copyWith(
          driverLocationResource: const Resource.error('Location permission denied'),
        ),
      );

      await tester.pumpWidget(
        makeTestable(
          const LocationDetailView.pickup(
            pickupInfo: storeInfo,
            userInfo: userInfo,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Location permission denied'), findsOneWidget);
      expect(find.text(MapConstants.retry), findsOneWidget);
      expect(find.byIcon(Icons.location_off), findsOneWidget);
    });

    testWidgets('renders map and address card when location is loaded', (tester) async {
      when(() => mockCubit.state).thenReturn(
        defaultState.copyWith(
          driverLocationResource: const Resource.success(LatLng(30.0, 31.0)),
          routeResource: const Resource.success(
            RouteData(
              points: [LatLng(30.0, 31.0), LatLng(30.0131, 31.2089)],
              distanceMeters: 2500,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        makeTestable(
          const LocationDetailView.pickup(
            pickupInfo: storeInfo,
            userInfo: userInfo,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LocationMapSection), findsOneWidget);
      expect(find.byType(LocationAddressCard), findsOneWidget);
      expect(find.text('2.5 km'), findsOneWidget);
    });
  });
}
