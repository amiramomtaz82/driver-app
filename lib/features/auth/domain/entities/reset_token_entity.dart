import 'package:equatable/equatable.dart';

class ResetToken extends Equatable {
  final String token;
  final DateTime expiresAt;

  const ResetToken({required this.token, required this.expiresAt});

  bool isExpired(DateTime now) => now.isAfter(expiresAt);

  @override
  List<Object?> get props => [token, expiresAt];
}
