class DriverLocationResponseDto {
  final double lat;
  final double lng;

  const DriverLocationResponseDto({
    required this.lat,
    required this.lng,
  });

  factory DriverLocationResponseDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json.containsKey('data') && json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    final lat = (data['lat'] ?? data['latitude'] as num?)?.toDouble() ?? 0.0;
    final lng =
        (data['lng'] ?? data['longitude'] ?? data['lon'] as num?)?.toDouble() ??
            0.0;

    return DriverLocationResponseDto(lat: lat, lng: lng);
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
