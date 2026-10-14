import '../models/available_orders_response_model.dart';
import '../models/order_details_dto.dart';
import '../models/order_history_response_model.dart';

abstract interface class OrdersRemoteDataSource {
  Future<AvailableOrdersDataModel> getAvailableOrders({
    required int page,
    required int pageSize,
  });

  Future<OrderHistoryDataModel> getOrderHistory({
    required int page,
    required int pageSize,
  });

  Future<void> acceptOrder({required String orderId});

  Future<OrderDetailsDto?> getActiveOrder();

  Future<OrderDetailsDto> getOrderDetails({required String orderId});

  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  });
}
