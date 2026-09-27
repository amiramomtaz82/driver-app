import 'package:json_annotation/json_annotation.dart';

import 'order_details_dto.dart';

part 'order_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class OrderDetailsResponseModel {
  const OrderDetailsResponseModel({this.data});

  @JsonKey(name: 'data', readValue: _readEnvelope)
  final OrderDetailsDto? data;

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseModelFromJson(json);
}

Object? _readEnvelope(Map<dynamic, dynamic> json, String key) =>
    json['data'] ?? json['value'];
