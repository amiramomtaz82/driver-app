import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_history_entity.dart';
import '../../../domain/entities/order_status.dart';
import '../../order_details/order_status_ui.dart';
import '../../home/widgets/order_party_tile.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order});

  final OrderHistoryEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.orders_flower_order.tr(), style: textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_statusIcon(), size: 16, color: _statusColor(context)),
                  const SizedBox(width: 4),
                  Text(
                    _statusLabel(),
                    style: textTheme.titleSmall?.copyWith(
                      color: _statusColor(context),
                    ),
                  ),
                ],
              ),
              Text(
                '# ${order.orderNumber}',
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.orders_pickup_address.tr(),
            style: textTheme.labelSmall,
          ),
          const SizedBox(height: 6),
          OrderPartyTile(
            name: order.storeName,
            address: order.storeAddress,
            avatarFallback: Icon(
              Icons.storefront,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(LocaleKeys.orders_user_address.tr(), style: textTheme.labelSmall),
          const SizedBox(height: 6),
          OrderPartyTile(
            name: order.recipientName,
            address: order.recipientAddress,
          ),
        ],
      ),
    );
  }

  String _statusLabel() {
    if (order.status == OrderStatus.delivered) {
      return LocaleKeys.orders_status_completed.tr();
    }
    return order.status.labelKey.tr();
  }

  Color _statusColor(BuildContext context) {
    final colors = context.customColors;
    switch (order.status) {
      case OrderStatus.delivered:
        return colors.success;
      case OrderStatus.cancelled:
        return colors.error;
      default:
        return colors.darkGrey;
    }
  }

  IconData _statusIcon() {
    switch (order.status) {
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }
}
