import 'package:equatable/equatable.dart';

import '../../../../../core/pagination/pagination_state.dart';
import '../../../domain/entities/order_history_entity.dart';

class OrderHistoryState extends Equatable {
  const OrderHistoryState({required this.pagination});

  OrderHistoryState.initial()
    : pagination = PaginationState<OrderHistoryEntity>.initial();

  final PaginationState<OrderHistoryEntity> pagination;

  List<OrderHistoryEntity> get orders => pagination.items;

  OrderHistoryState copyWith({
    PaginationState<OrderHistoryEntity>? pagination,
  }) {
    return OrderHistoryState(pagination: pagination ?? this.pagination);
  }

  @override
  List<Object?> get props => [pagination];
}
