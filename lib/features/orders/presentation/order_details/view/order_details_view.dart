import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_details_entity.dart';
import '../../../domain/entities/order_status.dart';
import '../manager/order_details_cubit.dart';
import '../manager/order_details_intents.dart';
import '../manager/order_details_state.dart';
import '../order_status_ui.dart';
import '../widgets/contact_party_card.dart';
import '../widgets/order_progress_bar.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView>
    with UiEventMixin<OrderDetailsView, OrderDetailsState, UiEvent> {
  @override
  BaseCubit<OrderDetailsState, UiEvent> get cubit =>
      context.read<OrderDetailsCubit>();

  @override
  void initState() {
    super.initState();
    context.read<OrderDetailsCubit>().onIntent(const OrderDetailsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(LocaleKeys.orders_order_details.tr()),
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            final resource = state.details;
            if (resource.isLoading && resource.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (resource.isError && resource.data == null) {
              return _ErrorRetry(
                message:
                    resource.errorMessage?.tr() ??
                    LocaleKeys.errors_something_went_wrong.tr(),
                onRetry: () => context.read<OrderDetailsCubit>().onIntent(
                  const OrderDetailsRetried(),
                ),
              );
            }

            final order = resource.data!;
            return Column(
              children: [
                Expanded(child: _Body(order: order)),
                _ActionBar(order: order, isBusy: state.isUpdatingStatus),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.order});

  final OrderDetailsEntity order;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderProgressBar(filled: order.status.progressCount),
          const SizedBox(height: 16),
          _StatusCard(order: order),
          const SizedBox(height: 20),
          _SectionLabel(LocaleKeys.orders_pickup_address.tr()),
          const SizedBox(height: 8),
          ContactPartyCard(
            party: order.pickup,
            avatarFallback: Icon(Icons.storefront, color: colors.primary),
            onCall: () => _todo(context, order.pickup.phone),
            onWhatsApp: () => _todo(context, order.pickup.phone),
          ),
          const SizedBox(height: 16),
          _SectionLabel(LocaleKeys.orders_user_address.tr()),
          const SizedBox(height: 8),
          ContactPartyCard(
            party: order.recipient,
            avatarFallback: Icon(Icons.person, color: colors.darkGrey),
            onCall: () => _todo(context, order.recipient.phone),
            onWhatsApp: () => _todo(context, order.recipient.phone),
          ),
          const SizedBox(height: 20),
          _SectionLabel(LocaleKeys.orders_order_details.tr(), large: true),
          const SizedBox(height: 8),
          ...order.items.map((item) => _ItemRow(item: item)),
          const SizedBox(height: 8),
          _SummaryRow(
            label: LocaleKeys.orders_total.tr(),
            value: _money(order.total, order.currency),
            emphasize: true,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: LocaleKeys.orders_payment_method.tr(),
            value: order.paymentMethod.isEmpty
                ? LocaleKeys.orders_cash_on_delivery.tr()
                : order.paymentMethod,
          ),
        ],
      ),
    );
  }

  void _todo(BuildContext context, String? phone) {
    if (phone == null || phone.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phone)));
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});

  final OrderDetailsEntity order;

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
            '${LocaleKeys.orders_status.tr()} : ${order.status.labelKey.tr()}',
            style: textTheme.titleSmall?.copyWith(color: colors.success),
          ),
          const SizedBox(height: 6),
          Text(
            '${LocaleKeys.orders_order_id.tr()} : # ${order.orderNumber}',
            style: textTheme.titleMedium,
          ),
          if (order.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              DateFormat('EEE, dd MMM yyyy, hh:mm a').format(order.createdAt!),
              style: textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

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
                const SizedBox(height: 4),
                Text(_money(item.price, ''), style: textTheme.bodyLarge),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.titleSmall),
          Text(
            value,
            style: emphasize
                ? textTheme.titleMedium
                : textTheme.bodyLarge?.copyWith(color: colors.darkGrey),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.large = false});

  final String text;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: large ? textTheme.titleSmall : textTheme.labelSmall,
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order, required this.isBusy});

  final OrderDetailsEntity order;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final status = order.status;

    if (status == OrderStatus.cancelled || status == OrderStatus.unknown) {
      return const SizedBox.shrink();
    }

    final actionLabelKey = status.actionLabelKey;
    final Widget button;

    if (status.isWaitingForCustomer || status == OrderStatus.delivered) {
      button = ElevatedButton(
        onPressed: null,
        child: Text(
          status == OrderStatus.delivered
              ? LocaleKeys.orders_status_delivered.tr()
              : LocaleKeys.orders_waiting_customer_confirmation.tr(),
        ),
      );
    } else if (actionLabelKey != null) {
      button = ElevatedButton(
        onPressed: isBusy ? null : () => _confirmAndAdvance(context),
        child: isBusy
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.white,
                ),
              )
            : Text(actionLabelKey.tr()),
      );
    } else {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(width: double.infinity, child: button),
      ),
    );
  }

  Future<void> _confirmAndAdvance(BuildContext context) async {
    final next = order.status.nextDriverStatus;
    if (next == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.orders_confirm_status_title.tr()),
        content: Text(
          LocaleKeys.orders_confirm_status_message.tr(
            namedArgs: {'status': next.labelKey.tr()},
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LocaleKeys.common_cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LocaleKeys.common_confirm.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<OrderDetailsCubit>().onIntent(const OrderStatusAdvanced());
    }
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(LocaleKeys.common_retry.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(double amount, String currency) {
  final formatted = amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  final unit = currency.isEmpty
      ? LocaleKeys.orders_currency_egp.tr()
      : currency;
  return '$unit $formatted';
}
