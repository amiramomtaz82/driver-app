import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/order_status.dart';

extension OrderStatusUi on OrderStatus {
  String get labelKey {
    switch (this) {
      case OrderStatus.preparing:
        return LocaleKeys.orders_status_accepted;
      case OrderStatus.pickedUp:
        return LocaleKeys.orders_status_picked;
      case OrderStatus.outForDelivery:
        return LocaleKeys.orders_status_out_for_delivery;
      case OrderStatus.awaitingDeliveryConfirmation:
        return LocaleKeys.orders_status_arrived;
      case OrderStatus.delivered:
        return LocaleKeys.orders_status_delivered;
      case OrderStatus.cancelled:
        return LocaleKeys.orders_status_cancelled;
      case OrderStatus.unknown:
        return LocaleKeys.orders_status_unknown;
    }
  }

  String? get actionLabelKey {
    switch (nextDriverStatus) {
      case OrderStatus.pickedUp:
        return LocaleKeys.orders_arrived_at_pickup;
      case OrderStatus.outForDelivery:
        return LocaleKeys.orders_start_deliver;
      case OrderStatus.awaitingDeliveryConfirmation:
        return LocaleKeys.orders_arrived_to_user;
      default:
        return null;
    }
  }
}
