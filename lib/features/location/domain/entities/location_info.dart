import 'package:equatable/equatable.dart';
import 'location_coordinates.dart';

class LocationInfo extends Equatable {
  final String name;
  final String address;
  final String? imageUrl;
  final LocationCoordinates coordinates;
  final String? phone;

  const LocationInfo({
    required this.name,
    required this.address,
    required this.coordinates,
    this.imageUrl,
    this.phone,
  });

  @override
  List<Object?> get props => [name, address, imageUrl, coordinates, phone];
}
