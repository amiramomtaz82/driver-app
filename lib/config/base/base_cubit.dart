import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State, UiEvent> extends Cubit<State> {
  BaseCubit(super.initialState);

  final StreamController<UiEvent> _uiEventStreamController =
  StreamController<UiEvent>();

  Stream<UiEvent> get eventStream => _uiEventStreamController.stream;

  void emitEvent(UiEvent event) {
    if (_uiEventStreamController.isClosed) return;

    _uiEventStreamController.add(event);
  }

  @override
  Future<void> close() {
    _uiEventStreamController.close();
    return super.close();
  }
}