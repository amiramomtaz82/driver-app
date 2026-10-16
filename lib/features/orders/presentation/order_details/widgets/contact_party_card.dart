import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';
import '../../../domain/entities/order_details_entity.dart';

class ContactPartyCard extends StatelessWidget {
  const ContactPartyCard({
    super.key,
    required this.party,
    required this.avatarFallback,
    this.onCall,
    this.onWhatsApp,
  });

  final OrderPartyEntity party;
  final Widget avatarFallback;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;
    final hasPhone = (party.phone ?? '').isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Avatar(imageUrl: party.imageUrl, fallback: avatarFallback),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  party.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colors.darkGrey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        party.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasPhone) ...[
            _ContactButton(icon: Icons.call, onTap: onCall),
            const SizedBox(width: 8),
            _ContactButton(icon: Icons.chat, onTap: onWhatsApp),
          ],
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: colors.primary),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl, required this.fallback});

  final String? imageUrl;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return ClipOval(
      child: Container(
        width: 44,
        height: 44,
        color: colors.surface,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Center(child: fallback)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(child: fallback),
              ),
      ),
    );
  }
}
