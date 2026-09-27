import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/features/location/presentation/widgets/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
class LocationMapSection extends StatelessWidget {
  const LocationMapSection({
    super.key,
    required this.driverLocation,
    required this.destinationLocation,
    required this.destinationLabel,
    required this.routePoints,
  });
  final LatLng driverLocation;
  final LatLng destinationLocation;
  final String destinationLabel;
  final List<LatLng> routePoints;
  @override
  Widget build(BuildContext context) {
    final centerLat =
        (driverLocation.latitude + destinationLocation.latitude) / 2;
    final centerLng =
        (driverLocation.longitude + destinationLocation.longitude) / 2;
    final center = LatLng(centerLat, centerLng);
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.driver_app',
        ),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: AppColors.pink,
                strokeWidth: 4.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: driverLocation,
              width: 90,
              height: 52,
              child: const LocationMarker(
                label: 'Your location',
                color: AppColors.success,
              ),
            ),
            Marker(
              point: destinationLocation,
              width: 80,
              height: 52,
              child: LocationMarker(
                label: destinationLabel,
                color: AppColors.pink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
