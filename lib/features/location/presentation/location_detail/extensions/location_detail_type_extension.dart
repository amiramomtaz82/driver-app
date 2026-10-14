import 'package:easy_localization/easy_localization.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../manager/location_detail_state.dart';

extension LocationDetailTypeExtension on LocationDetailType {
  String get primaryLabel => this == LocationDetailType.pickup
      ? LocaleKeys.orders_pickup_address.tr()
      : LocaleKeys.orders_user_address.tr();

  String get secondaryLabel => this == LocationDetailType.pickup
      ? LocaleKeys.orders_user_address.tr()
      : LocaleKeys.orders_pickup_address.tr();

  String get destinationLabel => this == LocationDetailType.pickup
      ? LocaleKeys.orders_store.tr()
      : LocaleKeys.orders_user.tr();
}
