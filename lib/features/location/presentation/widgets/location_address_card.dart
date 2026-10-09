import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/app_theme/text_styles.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class LocationAddressCard extends StatelessWidget {
  const LocationAddressCard({
    super.key,
    required this.primaryLabel,
    required this.primaryInfo,
    required this.secondaryLabel,
    required this.secondaryInfo,
  });
  final String primaryLabel;
  final LocationInfo primaryInfo;
  final String secondaryLabel;
  final LocationInfo secondaryInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          _InfoRow(label: primaryLabel, info: primaryInfo),
          const Divider(height: 24),
          _InfoRow(label: secondaryLabel, info: secondaryInfo),
        ],
      ),
    );
  }
}
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.info});
  final String label;
  final LocationInfo info;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: Theme.of(context).textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Avatar(imageUrl: info.imageUrl, name: info.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          info.address,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (info.phone != null) ...[
              _ActionButton(
                icon: Icons.phone_outlined,
                onTap: () => _launchPhone(info.phone!),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                onTap: () => _launchSms(info.phone!),
              ),
            ],
          ],
        ),
      ],
    );
  }
  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
  Future<void> _launchSms(String phone) async {
    final uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.name});
  final String? imageUrl;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.pink.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.pink,
                ),
              ),
            )
          : null,
    );
  }
}
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.pink, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.pink),
      ),
    );
  }
}
