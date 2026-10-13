import 'package:json_annotation/json_annotation.dart';

import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/order_history_entity.dart';
import '../../domain/entities/order_status.dart';
import 'available_order_dto.dart';

part 'order_history_response_model.g.dart';

@JsonSerializable(createToJson: false)
class OrderHistoryResponseModel {
  const OrderHistoryResponseModel({required this.data});

  final OrderHistoryDataModel data;

  factory OrderHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderHistoryDataModel {
  const OrderHistoryDataModel({this.items = const [], this.pagination});

  final List<OrderHistoryDto> items;
  final PaginationModel? pagination;

  factory OrderHistoryDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryDataModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderHistoryDto {
  const OrderHistoryDto({this.orderId, this.status, this.store, this.recipient});

  final String? orderId;
  final String? status;
  final OrderStoreDto? store;
  final OrderRecipientDto? recipient;

  factory OrderHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryDtoFromJson(json);

  OrderHistoryEntity toEntity() => OrderHistoryEntity(
    id: orderId ?? '',
    orderNumber: _shortNumber(orderId),
    status: OrderStatus.fromApi(status),
    storeName: store?.name ?? '',
    storeAddress: store?.address ?? '',
    recipientName: recipient?.name ?? '',
    recipientAddress: recipient?.fullAddress ?? '',
  );

  static String _shortNumber(String? id) {
    if (id == null || id.isEmpty) return '';
    final digits = id.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return id;
    return digits.substring(0, digits.length.clamp(0, 6));
  }
}
