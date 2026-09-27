import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';

class OrderProgressBar extends StatelessWidget {
  const OrderProgressBar({super.key, required this.filled, this.total = 5});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Row(
      children: List.generate(total, (index) {
        final isFilled = index < filled;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == total - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: isFilled ? colors.success : colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
