import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/widgets/location_address_card.dart';
import 'package:driver_app/features/location/presentation/widgets/location_map_section.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const storeInfo = LocationInfo(
    name: 'Flowery Store',
    address: 'Sheikh Zayed, Giza',
    coordinates: LocationCoordinates(latitude: 30.0131, longitude: 31.2089),
    phone: '01012345678',
  );

  const userInfo = LocationInfo(
    name: 'Nour Mohamed',
    address: 'Downtown, Cairo',
    coordinates: LocationCoordinates(latitude: 30.0444, longitude: 31.2357),
    phone: '01198765432',
  );

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('LocationMapSection Widget Tests —', () {
    testWidgets('renders map and markers correctly', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          const LocationMapSection(
            driverLocation:
                LocationCoordinates(latitude: 30.0, longitude: 31.0),
            destinationLocation:
                LocationCoordinates(latitude: 30.05, longitude: 31.05),
            destinationLabel: 'Store',
            routePoints: [
              LocationCoordinates(latitude: 30.0, longitude: 31.0),
              LocationCoordinates(latitude: 30.05, longitude: 31.05),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LocationMapSection), findsOneWidget);
      expect(find.text(LocaleKeys.orders_your_location.tr()), findsOneWidget);
      expect(find.text('Store'), findsOneWidget);
    });
  });

  group('LocationAddressCard Widget Tests —', () {
    testWidgets('renders address info correctly', (tester) async {
      await tester.pumpWidget(
        makeTestable(
          const LocationAddressCard(
            primaryLabel: 'Pickup address',
            primaryInfo: storeInfo,
            secondaryLabel: 'User address',
            secondaryInfo: userInfo,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pickup address'), findsOneWidget);
      expect(find.text('Flowery Store'), findsOneWidget);
      expect(find.text('Sheikh Zayed, Giza'), findsOneWidget);

      expect(find.text('User address'), findsOneWidget);
      expect(find.text('Nour Mohamed'), findsOneWidget);
      expect(find.text('Downtown, Cairo'), findsOneWidget);
    });

    testWidgets('triggers CallTapped when phone icon is tapped',
        (tester) async {
      LocationDetailIntent? receivedIntent;

      await tester.pumpWidget(
        makeTestable(
          LocationAddressCard(
            primaryLabel: 'Pickup address',
            primaryInfo: storeInfo,
            secondaryLabel: 'User address',
            secondaryInfo: userInfo,
            onIntent: (intent) => receivedIntent = intent,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final phoneButtons = find.byIcon(Icons.phone_outlined);
      expect(phoneButtons, findsNWidgets(2));

      await tester.tap(phoneButtons.first);
      await tester.pump();

      expect(receivedIntent, isA<CallTapped>());
      expect((receivedIntent as CallTapped).phone, storeInfo.phone);
    });

    testWidgets('triggers MessageTapped when message icon is tapped',
        (tester) async {
      LocationDetailIntent? receivedIntent;

      await tester.pumpWidget(
        makeTestable(
          LocationAddressCard(
            primaryLabel: 'Pickup address',
            primaryInfo: storeInfo,
            secondaryLabel: 'User address',
            secondaryInfo: userInfo,
            onIntent: (intent) => receivedIntent = intent,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final messageButtons = find.byIcon(Icons.chat_bubble_outline);
      expect(messageButtons, findsNWidgets(2));

      await tester.tap(messageButtons.last);
      await tester.pump();

      expect(receivedIntent, isA<MessageTapped>());
      expect((receivedIntent as MessageTapped).phone, userInfo.phone);
    });
  });
}
