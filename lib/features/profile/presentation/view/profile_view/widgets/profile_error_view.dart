import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/locale_keys.g.dart';

class ProfileErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const ProfileErrorView({
    super.key,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage ?? LocaleKeys.errors_something_went_wrong.tr()),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.common_retry.tr()),
          ),
        ],
      ),
    );
  }
}