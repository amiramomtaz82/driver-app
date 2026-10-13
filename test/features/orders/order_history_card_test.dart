import 'package:driver_app/features/orders/domain/entities/order_history_entity.dart';
import 'package:driver_app/features/orders/domain/entities/order_status.dart';
import 'package:driver_app/features/orders/presentation/order_history/widgets/order_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

OrderHistoryEntity _order(OrderStatus status) => OrderHistoryEntity(
  id: 'order-1',
  orderNumber: '123456',
  status: status,
  storeName: 'Flowery store',
  storeAddress: '20th st, Giza',
  recipientName: 'Nour Mohamed',
  recipientAddress: 'Maadi, Cairo',
);

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  group('OrderHistoryCard', () {
    testWidgets('renders store, recipient and order number', (tester) async {
      await tester.pumpWidget(
        _wrap(OrderHistoryCard(order: _order(OrderStatus.delivered))),
      );

      expect(find.text('Flowery store'), findsOneWidget);
      expect(find.text('Nour Mohamed'), findsOneWidget);
      expect(find.text('# 123456'), findsOneWidget);
    });

    testWidgets('shows the Completed label for a delivered order', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(OrderHistoryCard(order: _order(OrderStatus.delivered))),
      );

      expect(find.text('orders.status_completed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows the Cancelled label for a cancelled order', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(OrderHistoryCard(order: _order(OrderStatus.cancelled))),
      );

      expect(find.text('orders.status_cancelled'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('has no interactive button (display only)', (tester) async {
      await tester.pumpWidget(
        _wrap(OrderHistoryCard(order: _order(OrderStatus.delivered))),
      );

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });
  });
}
