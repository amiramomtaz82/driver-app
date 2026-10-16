import 'package:driver_app/features/orders/domain/entities/available_order_entity.dart';
import 'package:driver_app/features/orders/presentation/home/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _order = AvailableOrderEntity(
  id: 'order-1',
  orderNumber: '123456',
  totalAmount: 3000,
  currency: 'EGP',
  storeName: 'Flowery store',
  storeAddress: '20th st, Giza',
  recipientName: 'Nour Mohamed',
  recipientAddress: 'Maadi, Cairo',
);

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  group('OrderCard', () {
    testWidgets('renders store, recipient and price', (tester) async {
      await tester.pumpWidget(
        _wrap(OrderCard(order: _order, onAccept: () {})),
      );

      expect(find.text('Flowery store'), findsOneWidget);
      expect(find.text('Nour Mohamed'), findsOneWidget);
      expect(find.textContaining('3000'), findsOneWidget);
      expect(find.text('orders.accept'), findsOneWidget);
    });

    testWidgets('tapping Accept triggers onAccept', (tester) async {
      var accepted = false;
      await tester.pumpWidget(
        _wrap(OrderCard(order: _order, onAccept: () => accepted = true)),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(accepted, isTrue);
    });

    testWidgets('shows a spinner and disables the button while accepting', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(OrderCard(order: _order, onAccept: () {}, isAccepting: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('disables Accept when not enabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          OrderCard(order: _order, onAccept: () {}, isAcceptEnabled: false),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
