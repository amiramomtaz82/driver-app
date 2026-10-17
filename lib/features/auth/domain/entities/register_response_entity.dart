import 'package:equatable/equatable.dart';

class RegisterEntityResponse extends Equatable {
  final String? message;
  final String? token;
  final bool? success;

  const RegisterEntityResponse({
    this.message,
    this.token,
    this.success,
  });

  @override
  List<Object?> get props => [message, token, success];
}
