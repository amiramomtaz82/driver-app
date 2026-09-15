import 'package:equatable/equatable.dart';

enum ApiStatus { initial, loading, success, error }

class BaseState<E> extends Equatable {
  final E? data;
  final String? errorMessage;
  final ApiStatus status;

  const BaseState(this.status, this.data, this.errorMessage);

  const BaseState.loading({this.data})
      : status = ApiStatus.loading,
        errorMessage = null;

  const BaseState.success(this.data)
      : status = ApiStatus.success,
        errorMessage = null;

  const BaseState.error(String error, {this.data})
      : status = ApiStatus.error,
        errorMessage = error;

  const BaseState.initial()
      : status = ApiStatus.initial,
        data = null,
        errorMessage = null;

  bool get isSuccess => status == ApiStatus.success;
  bool get isLoading => status == ApiStatus.loading;
  bool get isError => status == ApiStatus.error;

  @override
  List<Object?> get props => [status, data, errorMessage];
}