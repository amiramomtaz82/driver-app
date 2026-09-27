import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';

part 'order_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderDetailsDto {
  const OrderDetailsDto({
    this.orderId,
    this.status,
    this.total,
    this.paymentMethod,
    this.pickup,
    this.userAddress,
    this.items,
  });

  final String? orderId;
  final String? status;
  final num? total;
  final String? paymentMethod;
  final OrderPickupDto? pickup;
  final OrderUserAddressDto? userAddress;
  final List<OrderItemDto>? items;

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  OrderDetailsEntity toEntity() => OrderDetailsEntity(
    id: orderId ?? '',
    orderNumber: _shortNumber(orderId),
    status: OrderStatus.fromApi(status),
    createdAt: null,
    total: total?.toDouble() ?? 0,
    currency: '',
    paymentMethod: paymentMethod ?? '',
    pickup: OrderPartyEntity(
      name: pickup?.storeName ?? '',
      address: pickup?.address ?? '',
      latitude: pickup?.location?.lat,
      longitude: pickup?.location?.lng,
    ),
    recipient: OrderPartyEntity(
      name: userAddress?.recipientName ?? '',
      address: userAddress?.address ?? '',
      phone: userAddress?.recipientPhone,
      latitude: userAddress?.location?.lat,
      longitude: userAddress?.location?.lng,
    ),
    items: (items ?? []).map((i) => i.toEntity()).toList(),
  );

  static String _shortNumber(String? id) {
    if (id == null || id.isEmpty) return '';
    final digits = id.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return id;
    return digits.substring(0, digits.length.clamp(0, 6));
  }
}

@JsonSerializable(createToJson: false)
class OrderPickupDto {
  const OrderPickupDto({this.storeName, this.address, this.location});

  final String? storeName;
  final String? address;
  final OrderLocationDto? location;

  factory OrderPickupDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPickupDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderUserAddressDto {
  const OrderUserAddressDto({
    this.recipientName,
    this.recipientPhone,
    this.address,
    this.location,
  });

  final String? recipientName;
  final String? recipientPhone;
  final String? address;
  final OrderLocationDto? location;

  factory OrderUserAddressDto.fromJson(Map<String, dynamic> json) =>
      _$OrderUserAddressDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderLocationDto {
  const OrderLocationDto({this.lat, this.lng});

  final double? lat;
  final double? lng;

  factory OrderLocationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLocationDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderItemDto {
  const OrderItemDto({this.productName, this.quantity, this.price, this.imageUrl});

  @JsonKey(name: 'productName')
  final String? productName;
  final int? quantity;
  final num? price;
  final String? imageUrl;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  OrderItemEntity toEntity() => OrderItemEntity(
    name: productName ?? '',
    quantity: quantity ?? 1,
    price: price?.toDouble() ?? 0,
    imageUrl: imageUrl,
  );
}
