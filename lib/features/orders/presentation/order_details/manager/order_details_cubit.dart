import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/resource/resource.dart';
import '../../../../../core/go_routes/routes_names.dart';
import '../../../domain/entities/order_details_entity.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/use_cases/get_order_details_use_case.dart';
import '../../../domain/use_cases/update_order_status_use_case.dart';
import 'order_details_intents.dart';
import 'order_details_state.dart';

const Duration kOrderPollInterval = Duration(seconds: 5);

@injectable
class OrderDetailsCubit extends BaseCubit<OrderDetailsState, UiEvent> {
  OrderDetailsCubit(
    @factoryParam this._orderId,
    this._getOrderDetailsUseCase,
    this._updateOrderStatusUseCase,
  ) : super(const OrderDetailsState());

  final String _orderId;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  Timer? _pollTimer;

  void onIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case OrderDetailsStarted():
      case OrderDetailsRetried():
        _load();
      case OrderStatusAdvanced():
        _advanceStatus();
    }
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(details: const Resource.loading()));
    final response = await _getOrderDetailsUseCase(orderId: _orderId);
    switch (response) {
      case SuccessResponse<OrderDetailsEntity>():
        emit(state.copyWith(details: Resource.success(response.data)));
        _onStatus(response.data.status);
      case ErrorResponse<OrderDetailsEntity>():
        if (!silent) {
          emit(state.copyWith(details: Resource.error(response.errMessage)));
        }
    }
  }

  Future<void> _advanceStatus() async {
    final current = state.details.data;
    if (current == null || state.isUpdatingStatus) return;

    final next = current.status.nextDriverStatus;
    if (next == null) return;

    emit(state.copyWith(isUpdatingStatus: true));
    final response = await _updateOrderStatusUseCase(
      orderId: _orderId,
      newStatus: next,
    );
    emit(state.copyWith(isUpdatingStatus: false));

    switch (response) {
      case SuccessResponse<void>():
        emit(
          state.copyWith(
            details: Resource.success(current.copyWith(status: next)),
          ),
        );
        _onStatus(next);
      case ErrorResponse<void>():
        emitEvent(
          ShowSnackBarEvent(message: response.errMessage.tr(), isError: true),
        );
    }
  }

  void _onStatus(OrderStatus status) {
    if (status == OrderStatus.delivered) {
      _stopPolling();
      emitEvent(const NavigateReplacementEvent(AppRoutes.orderSuccess));
      return;
    }

    if (status.isWaitingForCustomer) {
      _startPolling();
    } else {
      _stopPolling();
    }
  }

  void _startPolling() {
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(kOrderPollInterval, (_) => _load(silent: true));
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
