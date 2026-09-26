import 'package:json_annotation/json_annotation.dart';

import 'available_order_dto.dart';

part 'available_orders_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AvailableOrdersResponseModel {
  const AvailableOrdersResponseModel({required this.value});

  final AvailableOrdersDataModel value;

  factory AvailableOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class AvailableOrdersDataModel {
  const AvailableOrdersDataModel({
    this.items = const [],
    this.totalCount,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  final List<AvailableOrderDto> items;
  final int? totalCount;
  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  factory AvailableOrdersDataModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersDataModelFromJson(json);
}
