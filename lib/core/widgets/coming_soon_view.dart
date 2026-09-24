import 'package:flutter/material.dart';

/// Placeholder for tabs whose screen is not built yet.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$title\nComing soon',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
