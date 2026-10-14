import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/resource/resource.dart';
import '../../../../../core/pagination/pagination_controller.dart';
import '../../../domain/entities/order_history_entity.dart';
import '../../../domain/use_cases/get_order_history_use_case.dart';
import 'order_history_intents.dart';
import 'order_history_state.dart';

const int kOrderHistoryPageSize = 10;

@injectable
class OrderHistoryCubit extends BaseCubit<OrderHistoryState, UiEvent> {
  OrderHistoryCubit(GetOrderHistoryUseCase getOrderHistoryUseCase)
    : super(OrderHistoryState.initial()) {
    _paginationController = PaginationController<OrderHistoryEntity>(
      fetchPage: (page) => getOrderHistoryUseCase(
        page: page,
        pageSize: kOrderHistoryPageSize,
      ),
    );
  }

  late final PaginationController<OrderHistoryEntity> _paginationController;

  void onIntent(OrderHistoryIntent intent) {
    switch (intent) {
      case OrderHistoryStarted():
        _loadFirstPage();
      case OrderHistoryRefreshed():
        _refresh();
      case OrderHistoryLoadMore():
        _loadMore();
      case OrderHistoryRetried():
        _retry();
    }
  }

  Future<void> _loadFirstPage() async {
    emit(
      state.copyWith(
        pagination: _paginationController.state.copyWith(
          resource: const Resource.loading(),
        ),
      ),
    );
    emit(
      state.copyWith(pagination: await _paginationController.loadInitialPage()),
    );
  }

  Future<void> _refresh() async {
    emit(
      state.copyWith(pagination: await _paginationController.loadInitialPage()),
    );
  }

  Future<void> _loadMore() async {
    emit(
      state.copyWith(pagination: await _paginationController.loadNextPage()),
    );
  }

  Future<void> _retry() async {
    emit(
      state.copyWith(pagination: await _paginationController.retryLoadMore()),
    );
  }
}
