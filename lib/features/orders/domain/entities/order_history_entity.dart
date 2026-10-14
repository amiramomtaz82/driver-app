import 'package:equatable/equatable.dart';

import 'order_status.dart';

class OrderHistoryEntity extends Equatable {
  const OrderHistoryEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.storeName,
    required this.storeAddress,
    required this.recipientName,
    required this.recipientAddress,
  });

  final String id;
  final String orderNumber;
  final OrderStatus status;
  final String storeName;
  final String storeAddress;
  final String recipientName;
  final String recipientAddress;

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    storeName,
    storeAddress,
    recipientName,
    recipientAddress,
  ];
}
