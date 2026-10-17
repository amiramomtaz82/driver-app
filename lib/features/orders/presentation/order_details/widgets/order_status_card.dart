import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/extensions/date_time_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_status.dart';
import '../order_status_ui.dart';

/// The pink header card: current status, order id, and timestamp.
class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.status,
    required this.orderNumber,
    this.createdAt,
  });

  final OrderStatus status;
  final String orderNumber;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleKeys.orders_status.tr()} : ${status.labelKey.tr()}',
            style: textTheme.titleSmall?.copyWith(color: colors.success),
          ),
          const SizedBox(height: 6),
          Text(
            '${LocaleKeys.orders_order_id.tr()} : # $orderNumber',
            style: textTheme.titleMedium,
          ),
          if (createdAt != null) ...[
            const SizedBox(height: 6),
            Text(createdAt!.orderTimestamp, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
