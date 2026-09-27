import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/app_theme/text_styles.dart';
import 'package:flutter/material.dart';
class LocationMarker extends StatelessWidget {
  const LocationMarker({
    super.key,
    required this.label,
    required this.color,
    this.iconAsset,
  });
  final String label;
  final Color color;
  final String? iconAsset;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter(color: color),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }
}
class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
