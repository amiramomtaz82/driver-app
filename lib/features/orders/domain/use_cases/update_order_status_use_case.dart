import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/order_status.dart';
import '../repo/orders_repo.dart';

@injectable
class UpdateOrderStatusUseCase {
  UpdateOrderStatusUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<BaseResponse<void>> call({
    required String orderId,
    required OrderStatus newStatus,
  }) {
    return _ordersRepo.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
    );
  }
}
