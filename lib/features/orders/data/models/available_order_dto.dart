import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/available_order_entity.dart';

part 'available_order_dto.g.dart';

@JsonSerializable(createToJson: false)
class AvailableOrderDto {
  const AvailableOrderDto({
    this.id,
    this.orderNumber,
    this.totalAmount,
    this.currency,
    this.store,
    this.recipient,
  });

  final String? id;
  final String? orderNumber;
  final num? totalAmount;
  final String? currency;
  final OrderPartyDto? store;
  final OrderPartyDto? recipient;

  factory AvailableOrderDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrderDtoFromJson(json);

  AvailableOrderEntity toEntity() => AvailableOrderEntity(
    id: id ?? '',
    orderNumber: orderNumber ?? '',
    totalAmount: totalAmount?.toDouble() ?? 0,
    currency: currency ?? '',
    storeName: store?.name ?? '',
    storeAddress: store?.address ?? '',
    storeImageUrl: store?.imageUrl,
    recipientName: recipient?.name ?? '',
    recipientAddress: recipient?.address ?? '',
    recipientImageUrl: recipient?.imageUrl,
  );
}

@JsonSerializable(createToJson: false)
class OrderPartyDto {
  const OrderPartyDto({
    this.name,
    this.address,
    this.imageUrl,
    this.phone,
    this.latitude,
    this.longitude,
  });

  final String? name;
  final String? address;
  final String? imageUrl;
  final String? phone;
  final double? latitude;
  final double? longitude;

  factory OrderPartyDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPartyDtoFromJson(json);
}
