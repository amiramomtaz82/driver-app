import 'package:equatable/equatable.dart';

import '../../../../../core/pagination/pagination_state.dart';
import '../../../domain/entities/available_order_entity.dart';

class HomeState extends Equatable {
  const HomeState({required this.ordersPagination, this.acceptingOrderId});

  HomeState.initial()
    : ordersPagination = PaginationState<AvailableOrderEntity>.initial(),
      acceptingOrderId = null;

  final PaginationState<AvailableOrderEntity> ordersPagination;

  final String? acceptingOrderId;

  List<AvailableOrderEntity> get orders => ordersPagination.items;

  bool get isAccepting => acceptingOrderId != null;

  HomeState copyWith({
    PaginationState<AvailableOrderEntity>? ordersPagination,
    String? acceptingOrderId,
    bool clearAcceptingOrderId = false,
  }) {
    return HomeState(
      ordersPagination: ordersPagination ?? this.ordersPagination,
      acceptingOrderId: clearAcceptingOrderId
          ? null
          : acceptingOrderId ?? this.acceptingOrderId,
    );
  }

  @override
  List<Object?> get props => [ordersPagination, acceptingOrderId];
}
