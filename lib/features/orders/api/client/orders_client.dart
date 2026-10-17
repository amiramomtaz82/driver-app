import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/endpoints.dart';
import '../../data/models/available_orders_response_model.dart';
import '../../data/models/order_details_response_model.dart';
import 'orders_api_keys.dart';

part 'orders_client.g.dart';

@singleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(Endpoints.availableOrders)
  Future<AvailableOrdersResponseModel> getAvailableOrders({
    @Query(OrdersApiKeys.page) required int page,
    @Query(OrdersApiKeys.pageSize) required int pageSize,
  });

  @POST(Endpoints.acceptOrder)
  Future<void> acceptOrder(@Path(OrdersApiKeys.orderId) String orderId);

  @GET(Endpoints.activeOrder)
  Future<OrderDetailsResponseModel> getActiveOrder();

  @GET(Endpoints.driverOrderDetails)
  Future<OrderDetailsResponseModel> getOrderDetails(
    @Path(OrdersApiKeys.orderId) String orderId,
  );

  @PATCH(Endpoints.updateOrderStatus)
  Future<void> updateOrderStatus(
    @Path(OrdersApiKeys.orderId) String orderId,
    @Body() Map<String, dynamic> body,
  );
}
