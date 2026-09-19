import 'package:equatable/equatable.dart';

class AuthMessageEntity extends Equatable {
  final String? message;

  const AuthMessageEntity({this.message});

  @override
  List<Object?> get props => [message];
}
