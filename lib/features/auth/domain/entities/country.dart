import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String name;
  final String flag;
  final String code;

  const Country({
    required this.id,
    required this.name,
    required this.flag,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, flag, code];
}