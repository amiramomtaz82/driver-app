import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme/context_extension.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/order_status.dart';
import '../order_details/order_status_ui.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          _label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: color),
        ),
      ],
    );
  }

  String get _label {
    if (status == OrderStatus.delivered) {
      return LocaleKeys.orders_status_completed.tr();
    }
    return status.labelKey.tr();
  }

  Color _color(BuildContext context) {
    final colors = context.customColors;
    switch (status) {
      case OrderStatus.delivered:
        return colors.success;
      case OrderStatus.cancelled:
        return colors.error;
      default:
        return colors.darkGrey;
    }
  }

  IconData get _icon {
    switch (status) {
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }
}
