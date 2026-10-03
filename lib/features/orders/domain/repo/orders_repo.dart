import '../../../../config/base_response/base_response.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../entities/available_order_entity.dart';
import '../entities/order_details_entity.dart';
import '../entities/order_status.dart';

abstract interface class OrdersRepo {
  Future<BaseResponse<PaginatedResponse<AvailableOrderEntity>>>
  getAvailableOrders({required int page, required int pageSize});

  Future<BaseResponse<void>> acceptOrder({required String orderId});

  Future<BaseResponse<OrderDetailsEntity?>> getActiveOrder();

  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  });

  Future<BaseResponse<void>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });
}
