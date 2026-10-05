import 'package:equatable/equatable.dart';

class VehicleType extends Equatable {
  final String id;
  final String name;
  final String? icon;

  const VehicleType({
    required this.id,
    required this.name,
    this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}