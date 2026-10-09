import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../repo/orders_repo.dart';

@injectable
class AcceptOrderUseCase {
  AcceptOrderUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<BaseResponse<void>> call({required String orderId}) {
    return _ordersRepo.acceptOrder(orderId: orderId);
  }
}
