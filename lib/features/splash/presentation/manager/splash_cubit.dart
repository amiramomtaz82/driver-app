import 'package:injectable/injectable.dart';

import '../../../../config/base/base_cubit.dart';
import '../../../../config/base/ui_events.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../core/go_routes/routes_names.dart';
import '../../../auth/data/data_source/local_data_source.dart';
import '../../../orders/data/repo/orders_repo_imp.dart';
import '../../../orders/domain/entities/order_details_entity.dart';
import '../../../orders/domain/use_cases/get_active_order_use_case.dart';

@injectable
class SplashCubit extends BaseCubit<void, UiEvent> {
  SplashCubit(this._getActiveOrderUseCase, this._authLocalDataSource)
    : super(null);

  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final AuthLocalDataSource _authLocalDataSource;

  Future<void> decideStartDestination() async {
    if (!OrdersRepoImpl.useDummyData) {
      final token = await _authLocalDataSource.getToken();
      if (token == null || token.isEmpty) {
        emitEvent(const NavigateReplacementEvent(AppRoutes.login));
        return;
      }
    }

    final response = await _getActiveOrderUseCase();
    switch (response) {
      case SuccessResponse<OrderDetailsEntity?>():
        final active = response.data;
        if (active != null) {
          emitEvent(
            NavigateReplacementEvent(
              AppRoutes.orderDetails,
              arguments: active.id,
            ),
          );
        } else {
          emitEvent(const NavigateReplacementEvent(AppRoutes.home));
        }
      case ErrorResponse<OrderDetailsEntity?>():
        emitEvent(const NavigateReplacementEvent(AppRoutes.home));
    }
  }
}
