import 'package:json_annotation/json_annotation.dart';

import '../../../../core/pagination/pagination_model.dart';
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
  const AvailableOrdersDataModel({this.items = const [], this.pagination});

  final List<AvailableOrderDto> items;
  final PaginationModel? pagination;

  factory AvailableOrdersDataModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersDataModelFromJson(json);
}
