import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_history_entity.dart';
import '../../home/widgets/order_party_tile.dart';
import '../../widgets/order_status_chip.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order});

  final OrderHistoryEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push(AppRoutes.orderHistoryDetails, extra: order.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.orders_flower_order.tr(),
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderStatusChip(status: order.status),
                Text('# ${order.orderNumber}', style: textTheme.titleMedium),
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
            Text(
              LocaleKeys.orders_user_address.tr(),
              style: textTheme.labelSmall,
            ),
            const SizedBox(height: 6),
            OrderPartyTile(
              name: order.recipientName,
              address: order.recipientAddress,
            ),
          ],
        ),
      ),
    );
  }
}
