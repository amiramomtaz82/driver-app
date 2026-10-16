class DriverLocationRequestDto {
  final double lat;
  final double lng;
  final String recordedAt;

  const DriverLocationRequestDto({
    required this.lat,
    required this.lng,
    required this.recordedAt,
  });

  factory DriverLocationRequestDto.create({
    required double lat,
    required double lng,
  }) {
    return DriverLocationRequestDto(
      lat: lat,
      lng: lng,
      recordedAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  factory DriverLocationRequestDto.fromJson(Map<String, dynamic> json) {
    return DriverLocationRequestDto(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      recordedAt: json['recordedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'recordedAt': recordedAt,
      };
}
