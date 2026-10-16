import 'package:equatable/equatable.dart';

import 'order_status.dart';

class OrderDetailsEntity extends Equatable {
  const OrderDetailsEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.pickup,
    required this.recipient,
    required this.items,
    required this.total,
    required this.currency,
    required this.paymentMethod,
  });

  final String id;
  final String orderNumber;
  final OrderStatus status;
  final DateTime? createdAt;

  final OrderPartyEntity pickup;
  final OrderPartyEntity recipient;

  final List<OrderItemEntity> items;
  final double total;
  final String currency;
  final String paymentMethod;

  OrderDetailsEntity copyWith({OrderStatus? status}) => OrderDetailsEntity(
    id: id,
    orderNumber: orderNumber,
    status: status ?? this.status,
    createdAt: createdAt,
    pickup: pickup,
    recipient: recipient,
    items: items,
    total: total,
    currency: currency,
    paymentMethod: paymentMethod,
  );

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    createdAt,
    pickup,
    recipient,
    items,
    total,
    currency,
    paymentMethod,
  ];
}

class OrderPartyEntity extends Equatable {
  const OrderPartyEntity({
    required this.name,
    required this.address,
    this.phone,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String address;
  final String? phone;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [
    name,
    address,
    phone,
    imageUrl,
    latitude,
    longitude,
  ];
}

class OrderItemEntity extends Equatable {
  const OrderItemEntity({
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;

  @override
  List<Object?> get props => [name, quantity, price, imageUrl];
}
