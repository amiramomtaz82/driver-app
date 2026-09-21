import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../base/base_cubit.dart';
import '../base/ui_events.dart';

mixin UiEventMixin<
W extends StatefulWidget,
S,
E extends UiEvent> on State<W> {

  BaseCubit<S, E> get cubit;

  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = cubit.eventStream.listen(
      _handleUiEvent,
    );
  }

  void _handleUiEvent(E event) {
    if (!mounted) return;

    switch (event) {
      case ShowSnackBarEvent():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.message.tr()),
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
        Navigator.of(context).pop(
          event.result,
        );

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

  void onCustomUiEvent(E event) {}

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}