import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class PaginationFooter extends StatelessWidget {
  const PaginationFooter({
    super.key,
    required this.isLoadingMore,
    required this.hasNextPage,
    this.loadMoreError,
    this.onRetry,
  });

  final bool isLoadingMore;
  final bool hasNextPage;
  final String? loadMoreError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              loadMoreError!.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text(LocaleKeys.common_retry.tr()),
            ),
          ],
        ),
      );
    }

    if (!hasNextPage) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            LocaleKeys.common_no_more_items.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
