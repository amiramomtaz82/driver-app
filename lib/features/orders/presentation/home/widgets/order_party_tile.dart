import 'package:flutter/material.dart';

import '../../../../../core/app_theme/context_extension.dart';

class OrderPartyTile extends StatelessWidget {
  const OrderPartyTile({
    super.key,
    required this.name,
    required this.address,
    this.imageUrl,
    this.avatarFallback,
  });

  final String name;
  final String address;
  final String? imageUrl;

  final Widget? avatarFallback;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _Avatar(imageUrl: imageUrl, fallback: avatarFallback),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
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
                        address,
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
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl, this.fallback});

  final String? imageUrl;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final placeholder =
        fallback ?? Icon(Icons.person, size: 20, color: colors.white);

    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        color: colors.surface,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Center(child: placeholder)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(child: placeholder),
              ),
      ),
    );
  }
}
