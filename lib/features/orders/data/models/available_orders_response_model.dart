import 'package:json_annotation/json_annotation.dart';

import 'available_order_dto.dart';

part 'available_orders_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AvailableOrdersResponseModel {
  const AvailableOrdersResponseModel({required this.data});

  final AvailableOrdersDataModel data;

  factory AvailableOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class AvailableOrdersDataModel {
  const AvailableOrdersDataModel({
    this.items = const [],
    this.pagination,
  });

  final List<AvailableOrderDto> items;
  final PaginationDto? pagination;

  factory AvailableOrdersDataModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersDataModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaginationDto {
  const PaginationDto({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}
