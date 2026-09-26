import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import 'available_order_dto.dart';

part 'order_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderDetailsDto {
  const OrderDetailsDto({
    this.id,
    this.orderNumber,
    this.status,
    this.createdAt,
    this.totalAmount,
    this.currency,
    this.paymentMethod,
    this.store,
    this.recipient,
    this.items,
  });

  final String? id;
  final String? orderNumber;
  final String? status;
  final String? createdAt;
  final num? totalAmount;
  final String? currency;
  final String? paymentMethod;
  final OrderPartyDto? store;
  final OrderPartyDto? recipient;
  final List<OrderItemDto>? items;

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  OrderDetailsEntity toEntity() => OrderDetailsEntity(
    id: id ?? '',
    orderNumber: orderNumber ?? '',
    status: OrderStatus.fromApi(status),
    createdAt: DateTime.tryParse(createdAt ?? ''),
    total: totalAmount?.toDouble() ?? 0,
    currency: currency ?? '',
    paymentMethod: paymentMethod ?? '',
    pickup: OrderPartyEntity(
      name: store?.name ?? '',
      address: store?.address ?? '',
      phone: store?.phone,
      imageUrl: store?.imageUrl,
      latitude: store?.latitude,
      longitude: store?.longitude,
    ),
    recipient: OrderPartyEntity(
      name: recipient?.name ?? '',
      address: recipient?.address ?? '',
      phone: recipient?.phone,
      imageUrl: recipient?.imageUrl,
      latitude: recipient?.latitude,
      longitude: recipient?.longitude,
    ),
    items: (items ?? []).map((i) => i.toEntity()).toList(),
  );
}

@JsonSerializable(createToJson: false)
class OrderItemDto {
  const OrderItemDto({this.name, this.quantity, this.price, this.imageUrl});

  final String? name;
  final int? quantity;
  final num? price;
  final String? imageUrl;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  OrderItemEntity toEntity() => OrderItemEntity(
    name: name ?? '',
    quantity: quantity ?? 1,
    price: price?.toDouble() ?? 0,
    imageUrl: imageUrl,
  );
}
