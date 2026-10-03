import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_status.dart';
import '../manager/order_details_cubit.dart';
import '../manager/order_details_intents.dart';
import '../order_status_ui.dart';

/// The sticky bottom bar: the next status action (with a confirmation dialog),
/// a disabled "waiting for the customer" state, or nothing for terminal states.
class OrderActionBar extends StatelessWidget {
  const OrderActionBar({
    super.key,
    required this.status,
    required this.isBusy,
  });

  final OrderStatus status;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

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
    final next = status.nextDriverStatus;
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
