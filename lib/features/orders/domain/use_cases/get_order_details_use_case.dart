import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/order_details_entity.dart';
import '../repo/orders_repo.dart';

@injectable
class GetOrderDetailsUseCase {
  GetOrderDetailsUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<BaseResponse<OrderDetailsEntity>> call({required String orderId}) {
    return _ordersRepo.getOrderDetails(orderId: orderId);
  }
}
