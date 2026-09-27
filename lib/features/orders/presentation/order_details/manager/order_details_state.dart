import 'package:equatable/equatable.dart';

import '../../../../../config/resource/resource.dart';
import '../../../domain/entities/order_details_entity.dart';

class OrderDetailsState extends Equatable {
  const OrderDetailsState({
    this.details = const Resource.initial(),
    this.isUpdatingStatus = false,
  });

  final Resource<OrderDetailsEntity> details;

  final bool isUpdatingStatus;

  OrderDetailsState copyWith({
    Resource<OrderDetailsEntity>? details,
    bool? isUpdatingStatus,
  }) {
    return OrderDetailsState(
      details: details ?? this.details,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }

  @override
  List<Object?> get props => [details, isUpdatingStatus];
}
