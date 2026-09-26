enum OrderStatus {
  preparing,
  pickedUp,
  outForDelivery,
  awaitingDeliveryConfirmation,
  delivered,
  cancelled,
  unknown;

  static OrderStatus fromApi(String? value) {
    switch (value) {
      case 'Preparing':
      case 'Accepted':
      case 'Confirmed':
        return OrderStatus.preparing;
      case 'PickedUp':
        return OrderStatus.pickedUp;
      case 'OutForDelivery':
        return OrderStatus.outForDelivery;
      case 'AwaitingDeliveryConfirmation':
        return OrderStatus.awaitingDeliveryConfirmation;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }

  String? get apiValue {
    switch (this) {
      case OrderStatus.pickedUp:
        return 'PickedUp';
      case OrderStatus.outForDelivery:
        return 'OutForDelivery';
      case OrderStatus.awaitingDeliveryConfirmation:
        return 'AwaitingDeliveryConfirmation';
      default:
        return null;
    }
  }
}

const List<OrderStatus> kOrderProgressSteps = [
  OrderStatus.preparing,
  OrderStatus.pickedUp,
  OrderStatus.outForDelivery,
  OrderStatus.awaitingDeliveryConfirmation,
  OrderStatus.delivered,
];

extension OrderStatusProgress on OrderStatus {
  int get progressCount {
    switch (this) {
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.pickedUp:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.awaitingDeliveryConfirmation:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
      case OrderStatus.unknown:
        return 0;
    }
  }

  OrderStatus? get nextDriverStatus {
    switch (this) {
      case OrderStatus.preparing:
        return OrderStatus.pickedUp;
      case OrderStatus.pickedUp:
        return OrderStatus.outForDelivery;
      case OrderStatus.outForDelivery:
        return OrderStatus.awaitingDeliveryConfirmation;
      case OrderStatus.awaitingDeliveryConfirmation:
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.unknown:
        return null;
    }
  }

  bool get isWaitingForCustomer =>
      this == OrderStatus.awaitingDeliveryConfirmation;
}
