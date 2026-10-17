import 'package:equatable/equatable.dart';

class AvailableOrderEntity extends Equatable {
  const AvailableOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.currency,
    required this.storeName,
    required this.storeAddress,
    required this.recipientName,
    required this.recipientAddress,
    this.storeImageUrl,
    this.recipientImageUrl,
  });

  final String id;
  final String orderNumber;
  final double totalAmount;
  final String currency;

  final String storeName;
  final String storeAddress;
  final String? storeImageUrl;

  final String recipientName;
  final String recipientAddress;
  final String? recipientImageUrl;

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    totalAmount,
    currency,
    storeName,
    storeAddress,
    storeImageUrl,
    recipientName,
    recipientAddress,
    recipientImageUrl,
  ];
}
