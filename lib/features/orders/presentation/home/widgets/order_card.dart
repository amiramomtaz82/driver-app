import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/available_order_entity.dart';
import 'order_party_tile.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onAccept,
    this.isAccepting = false,
    this.isAcceptEnabled = true,
  });

  final AvailableOrderEntity order;
  final VoidCallback onAccept;

  final bool isAccepting;

  final bool isAcceptEnabled;

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
          Text(
            LocaleKeys.orders_flower_order.tr(),
            style: textTheme.titleSmall,
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
            imageUrl: order.storeImageUrl,
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
            imageUrl: order.recipientImageUrl,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text(_price(), style: textTheme.titleMedium)),
              SizedBox(
                width: 130,
                height: 44,
                child: ElevatedButton(
                  onPressed: isAcceptEnabled && !isAccepting ? onAccept : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: isAccepting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.white,
                          ),
                        )
                      : Text(LocaleKeys.orders_accept.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _price() {
    final amount = order.totalAmount;
    final formatted = amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
    final currency = order.currency.isEmpty
        ? LocaleKeys.orders_currency_egp.tr()
        : order.currency;

    return '$currency $formatted';
  }
}
