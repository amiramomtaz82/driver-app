import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/resource/resource.dart';
import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../core/pagination/pagination_controller.dart';
import '../../../domain/entities/available_order_entity.dart';
import '../../../domain/use_cases/accept_order_use_case.dart';
import '../../../domain/use_cases/get_available_orders_use_case.dart';
import 'home_intents.dart';
import 'home_state.dart';

const int kAvailableOrdersPageSize = 10;

@injectable
class HomeCubit extends BaseCubit<HomeState, UiEvent> {
  HomeCubit(
    this._acceptOrderUseCase,
    GetAvailableOrdersUseCase getAvailableOrdersUseCase,
  ) : super(HomeState.initial()) {
    _paginationController = PaginationController<AvailableOrderEntity>(
      fetchPage: (page) => getAvailableOrdersUseCase(
        page: page,
        pageSize: kAvailableOrdersPageSize,
      ),
    );
  }

  final AcceptOrderUseCase _acceptOrderUseCase;
  late final PaginationController<AvailableOrderEntity> _paginationController;

  void onIntent(HomeIntent intent) {
    switch (intent) {
      case HomeStarted():
        _loadFirstPage();
      case HomeRefreshed():
        _refresh();
      case HomeLoadMore():
        _loadMore();
      case HomeRetried():
        _retry();
      case OrderAccepted():
        _acceptOrder(intent.orderId);
    }
  }

  Future<void> _loadFirstPage() async {
    emit(
      state.copyWith(
        ordersPagination: _paginationController.state.copyWith(
          resource: const Resource.loading(),
        ),
      ),
    );
    emit(
      state.copyWith(
        ordersPagination: await _paginationController.loadInitialPage(),
      ),
    );
  }

  Future<void> _refresh() async {
    emit(
      state.copyWith(
        ordersPagination: await _paginationController.loadInitialPage(),
      ),
    );
  }

  Future<void> _loadMore() async {
    emit(
      state.copyWith(
        ordersPagination: await _paginationController.loadNextPage(),
      ),
    );
  }

  Future<void> _retry() async {
    emit(
      state.copyWith(
        ordersPagination: await _paginationController.retryLoadMore(),
      ),
    );
  }

  Future<void> _acceptOrder(String orderId) async {
    if (state.isAccepting) return;

    emit(state.copyWith(acceptingOrderId: orderId));
    final response = await _acceptOrderUseCase(orderId: orderId);
    emit(state.copyWith(clearAcceptingOrderId: true));

    switch (response) {
      case SuccessResponse<void>():
        // Lock the driver onto the order: no way back to Home until it is done.
        emitEvent(
          NavigateReplacementEvent(AppRoutes.orderDetails, arguments: orderId),
        );
      case ErrorResponse<void>():
        // Most likely another driver claimed it first; refresh drops it.
        emitEvent(
          ShowSnackBarEvent(message: response.errMessage.tr(), isError: true),
        );
        await _refresh();
    }
  }
}
