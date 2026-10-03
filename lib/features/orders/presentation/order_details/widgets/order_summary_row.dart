import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';

/// A label/value row in the order summary (Total, Payment method...).
class OrderSummaryRow extends StatelessWidget {
  const OrderSummaryRow({
    super.key,
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

class OrderSectionLabel extends StatelessWidget {
  const OrderSectionLabel(this.text, {super.key, this.large = false});

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
