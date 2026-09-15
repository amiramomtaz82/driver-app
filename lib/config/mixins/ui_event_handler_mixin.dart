import 'dart:async';

import 'package:flutter/material.dart';

import '../base/base_cubit.dart';

import '../base/ui_events.dart';

mixin UiEventMixin<T extends StatefulWidget> on State<T> {
  BaseCubit get cubit;

  StreamSubscription<UiEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = cubit.uiEvents.listen(
      _handleUiEvent,
    );
  }

  void _handleUiEvent(UiEvent event) {
    if (!mounted) return;

    switch (event) {
      case ShowSnackBarEvent():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.message),
          ),
        );

      case NavigateEvent():
        Navigator.of(context).pushNamed(
          event.route,
          arguments: event.arguments,
        );

      case NavigateReplacementEvent():
        Navigator.of(context).pushReplacementNamed(
          event.route,
          arguments: event.arguments,
        );

      case PopEvent():
        Navigator.of(context).pop(event.result);

      case ShowDialogEvent():
        showDialog<void>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(event.title),
              content: Text(event.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

      default:
        onCustomUiEvent(event);
    }
  }

  void onCustomUiEvent(UiEvent event) {}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}