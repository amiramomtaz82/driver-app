import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../entities/available_order_entity.dart';
import '../repo/orders_repo.dart';

@injectable
class GetAvailableOrdersUseCase {
  GetAvailableOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<BaseResponse<PaginatedResponse<AvailableOrderEntity>>> call({
    required int page,
    required int pageSize,
  }) {
    return _ordersRepo.getAvailableOrders(page: page, pageSize: pageSize);
  }
}
