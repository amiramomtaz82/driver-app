import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/available_order_entity.dart';

part 'available_order_dto.g.dart';

@JsonSerializable(createToJson: false)
class AvailableOrderDto {
  const AvailableOrderDto({
    this.orderId,
    this.status,
    this.total,
    this.itemCount,
    this.store,
    this.recipient,
  });

  final String? orderId;
  final String? status;
  final num? total;
  final int? itemCount;
  final OrderStoreDto? store;
  final OrderRecipientDto? recipient;

  factory AvailableOrderDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrderDtoFromJson(json);

  AvailableOrderEntity toEntity() => AvailableOrderEntity(
    id: orderId ?? '',
    orderNumber: _shortNumber(orderId),
    totalAmount: total?.toDouble() ?? 0,
    currency: '',
    storeName: store?.name ?? '',
    storeAddress: store?.address ?? '',
    recipientName: recipient?.name ?? '',
    recipientAddress: recipient?.fullAddress ?? '',
  );

  static String _shortNumber(String? id) {
    if (id == null || id.isEmpty) return '';
    final digits = id.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? id.substring(0, 6) : digits.substring(0, digits.length.clamp(0, 6));
  }
}

@JsonSerializable(createToJson: false)
class OrderStoreDto {
  const OrderStoreDto({this.name, this.address, this.phone});

  final String? name;
  final String? address;
  final String? phone;

  factory OrderStoreDto.fromJson(Map<String, dynamic> json) =>
      _$OrderStoreDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderRecipientDto {
  const OrderRecipientDto({
    this.name,
    this.address,
    this.city,
    this.area,
    this.phone,
  });

  final String? name;
  final String? address;
  final String? city;
  final String? area;
  final String? phone;

  factory OrderRecipientDto.fromJson(Map<String, dynamic> json) =>
      _$OrderRecipientDtoFromJson(json);

  String get fullAddress {
    if (address != null && address!.isNotEmpty) return address!;
    return [area, city].where((p) => p != null && p.isNotEmpty).join(', ');
  }
}
