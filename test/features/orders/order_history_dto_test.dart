import 'package:driver_app/features/orders/data/models/available_order_dto.dart';
import 'package:driver_app/features/orders/data/models/order_history_response_model.dart';
import 'package:driver_app/features/orders/domain/entities/order_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderHistoryDto.toEntity', () {
    test('maps fields and parses the status', () {
      const dto = OrderHistoryDto(
        orderId: '123456-abc',
        status: 'Delivered',
        store: OrderStoreDto(name: 'Flowery store', address: 'Giza'),
        recipient: OrderRecipientDto(
          name: 'Nour',
          city: 'Cairo',
          area: 'Downtown',
        ),
      );

      final entity = dto.toEntity();

      expect(entity.id, '123456-abc');
      expect(entity.orderNumber, '123456');
      expect(entity.status, OrderStatus.delivered);
      expect(entity.storeName, 'Flowery store');
      expect(entity.storeAddress, 'Giza');
      expect(entity.recipientName, 'Nour');
      expect(entity.recipientAddress, 'Downtown, Cairo');
    });

    test('maps Cancelled status and degrades missing fields', () {
      const dto = OrderHistoryDto(orderId: '', status: 'Cancelled');

      final entity = dto.toEntity();

      expect(entity.status, OrderStatus.cancelled);
      expect(entity.orderNumber, '');
      expect(entity.storeName, '');
      expect(entity.recipientName, '');
    });

    test('unknown status falls back to OrderStatus.unknown', () {
      const dto = OrderHistoryDto(orderId: '1', status: 'Weird');
      expect(dto.toEntity().status, OrderStatus.unknown);
    });
  });
}
