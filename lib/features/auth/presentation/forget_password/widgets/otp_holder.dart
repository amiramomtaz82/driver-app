import 'package:driver_app/core/app_theme/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

/// Pass [errorText] to turn the boxes red and show the message under them,
/// pass `null` to go back to the normal state.
class OtpHolder extends StatelessWidget {
  const OtpHolder({
    super.key,
    this.controller,
    this.focusNode,
    this.length = 6,
    this.errorText,
    this.onCompleted,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int length;

  /// `null` -> normal state, otherwise the boxes are painted with the error
  /// color and this text is shown under them.
  final String? errorText;

  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  static const double _spacing = 8;
  static const double _maxBoxSize = 56;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Shrink the boxes so all of them fit on narrow phones.
        final boxSize = ((constraints.maxWidth - _spacing * (length - 1)) /
                length)
            .clamp(0.0, _maxBoxSize);
        return _buildPinput(context, boxSize);
      },
    );
  }

  Widget _buildPinput(BuildContext context, double boxSize) {
    final theme = context.theme;
    final colors = context.customColors;

    final defaultPinTheme = PinTheme(
      width: boxSize,
      height: boxSize,
      textStyle: theme.textTheme.headlineLarge,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      mainAxisAlignment: MainAxisAlignment.center,
      separatorBuilder: (_) => const SizedBox(width: _spacing),
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(color: colors.primary, width: 1.5),
      ),
      submittedPinTheme: defaultPinTheme,
      errorPinTheme: defaultPinTheme.copyDecorationWith(
        color: theme.scaffoldBackgroundColor,
        border: Border.all(color: colors.error, width: 1.5),
      ),
      forceErrorState: errorText != null,
      errorText: errorText,
      errorBuilder: (errorText, pin) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.error_outline, size: 16, color: colors.error),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                errorText ?? '',
                style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
              ),
            ),
          ],
        ),
      ),
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
