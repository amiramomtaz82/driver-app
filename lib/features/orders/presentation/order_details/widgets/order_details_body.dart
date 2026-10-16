import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/extensions/num_money_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_details_entity.dart';
import '../../../domain/entities/order_status.dart';
import '../manager/order_details_cubit.dart';
import '../manager/order_details_state.dart';
import 'contact_party_card.dart';
import 'order_item_row.dart';
import 'order_progress_bar.dart';
import 'order_status_card.dart';
import 'order_summary_row.dart';

/// Scrollable order-details content. The pieces that depend on the live status
/// (progress bar, status card) rebuild on their own via [BlocSelector]; the
/// rest is built once from the loaded [order].
class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody({super.key, required this.order});

  final OrderDetailsEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusSection(order: order),
          const SizedBox(height: 20),
          OrderSectionLabel(LocaleKeys.orders_pickup_address.tr()),
          const SizedBox(height: 8),
          ContactPartyCard(
            party: order.pickup,
            avatarFallback: Icon(Icons.storefront, color: colors.primary),
            onCall: () => _showPhone(context, order.pickup.phone),
            onWhatsApp: () => _showPhone(context, order.pickup.phone),
          ),
          const SizedBox(height: 16),
          OrderSectionLabel(LocaleKeys.orders_user_address.tr()),
          const SizedBox(height: 8),
          ContactPartyCard(
            party: order.recipient,
            avatarFallback: Icon(Icons.person, color: colors.darkGrey),
            onCall: () => _showPhone(context, order.recipient.phone),
            onWhatsApp: () => _showPhone(context, order.recipient.phone),
          ),
          const SizedBox(height: 20),
          OrderSectionLabel(LocaleKeys.orders_order_details.tr(), large: true),
          const SizedBox(height: 8),
          ...order.items.map((item) => OrderItemRow(item: item)),
          if (order.total > 0) ...[
            const SizedBox(height: 8),
            OrderSummaryRow(
              label: LocaleKeys.orders_total.tr(),
              value: order.total.formatMoney(
                order.currency.isEmpty
                    ? LocaleKeys.orders_currency_egp.tr()
                    : order.currency,
              ),
              emphasize: true,
            ),
          ],
          if (order.paymentMethod.isNotEmpty) ...[
            const SizedBox(height: 8),
            OrderSummaryRow(
              label: LocaleKeys.orders_payment_method.tr(),
              value: order.paymentMethod,
            ),
          ],
        ],
      ),
    );
  }

  // Calling / WhatsApp needs url_launcher (not yet in pubspec); shows the
  // number for now so the buttons are testable.
  void _showPhone(BuildContext context, String? phone) {
    if (phone == null || phone.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phone)));
  }
}

/// Progress bar + status card, rebuilt only when the order status changes.
class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.order});

  final OrderDetailsEntity order;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrderDetailsCubit, OrderDetailsState, OrderStatus>(
      selector: (state) => state.details.data?.status ?? order.status,
      builder: (context, status) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderProgressBar(filled: status.progressCount),
            const SizedBox(height: 16),
            OrderStatusCard(
              status: status,
              orderNumber: order.orderNumber,
              createdAt: order.createdAt,
            ),
          ],
        );
      },
    );
  }
}
