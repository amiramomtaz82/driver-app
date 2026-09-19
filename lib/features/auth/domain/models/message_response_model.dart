import 'package:json_annotation/json_annotation.dart';

part 'message_response_model.g.dart';

@JsonSerializable(createToJson: false)
class MessageResponseModel {
  @JsonKey(readValue: _readFromValue)
  final String? message;

  const MessageResponseModel({this.message});

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseModelFromJson(json);
}

Object? _readFromValue(Map json, String key) => (json['value'] as Map?)?[key];
