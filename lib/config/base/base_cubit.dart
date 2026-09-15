import 'dart:async';

import 'package:driver_app/config/base/ui_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';


abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState.initial());

  final StreamController<UiEvent> _uiEventController =
  StreamController<UiEvent>.broadcast();

  Stream<UiEvent> get uiEvents => _uiEventController.stream;

  void emitUiEvent(UiEvent event) {
    if (!_uiEventController.isClosed) {
      _uiEventController.add(event);
    }
  }

  void emitLoading({T? data}) {
    emit(BaseState.loading(data: data));
  }

  void emitSuccess(T data) {
    emit(BaseState.success(data));
  }

  void emitError(String message, {T? data}) {
    emit(
      BaseState.error(
        message,
        data: data,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _uiEventController.close();
    return super.close();
  }
}