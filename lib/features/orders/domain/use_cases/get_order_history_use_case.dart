import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../entities/order_history_entity.dart';
import '../repo/orders_repo.dart';

@injectable
class GetOrderHistoryUseCase {
  GetOrderHistoryUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<BaseResponse<PaginatedResponse<OrderHistoryEntity>>> call({
    required int page,
    required int pageSize,
  }) {
    return _ordersRepo.getOrderHistory(page: page, pageSize: pageSize);
  }
}
