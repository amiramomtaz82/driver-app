import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/extensions/num_money_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_details_entity.dart';

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({super.key, required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              color: colors.surface,
              child: Icon(Icons.local_florist, size: 20, color: colors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: textTheme.bodyMedium),
                if (item.price > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.price.formatMoney(LocaleKeys.orders_currency_egp.tr()),
                    style: textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
          Text(
            LocaleKeys.orders_quantity_short.tr(
              namedArgs: {'count': '${item.quantity}'},
            ),
            style: textTheme.bodyLarge?.copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}
