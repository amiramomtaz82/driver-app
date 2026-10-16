extension MoneyFormatting on num {
  String formatMoney(String unit) {
    final value = toDouble();
    final formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$unit $formatted';
  }
}
