import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source/orders_remote_data_source.dart';
import '../../data/models/available_orders_response_model.dart';
import '../../data/models/order_details_dto.dart';
import '../client/orders_client.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._ordersApiClient);

  final OrdersApiClient _ordersApiClient;

  @override
  Future<AvailableOrdersDataModel> getAvailableOrders({
    required int page,
    required int pageSize,
  }) async {
    final response = await _ordersApiClient.getAvailableOrders(
      page: page,
      pageSize: pageSize,
    );
    return response.data;
  }

  @override
  Future<void> acceptOrder({required String orderId}) {
    return _ordersApiClient.acceptOrder(orderId);
  }

  @override
  Future<OrderDetailsDto?> getActiveOrder() async {
    try {
      final response = await _ordersApiClient.getActiveOrder();
      return response.data;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 204) return null;
      rethrow;
    }
  }

  @override
  Future<OrderDetailsDto> getOrderDetails({required String orderId}) async {
    final response = await _ordersApiClient.getOrderDetails(orderId);
    return response.data ?? const OrderDetailsDto();
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) {
    return _ordersApiClient.updateOrderStatus(orderId, {
      'newStatus': newStatus,
    });
  }
}
