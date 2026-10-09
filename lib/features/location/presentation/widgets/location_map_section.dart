import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/features/location/presentation/widgets/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapSection extends StatefulWidget {
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
  State<LocationMapSection> createState() => _LocationMapSectionState();
}

class _LocationMapSectionState extends State<LocationMapSection> {
  final MapController _mapController = MapController();
  bool _initialFitDone = false;

  @override
  void didUpdateWidget(covariant LocationMapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverLocation != widget.driverLocation) {
      _fitBounds();
    }
  }

  void _fitBounds() {
    final bounds = LatLngBounds.fromPoints([
      widget.driverLocation,
      widget.destinationLocation,
    ]);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(80),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.driverLocation,
        initialZoom: 14,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onMapReady: () {
          if (!_initialFitDone) {
            _initialFitDone = true;
            _fitBounds();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.driver_app',
        ),
        if (widget.routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.routePoints,
                color: AppColors.pink,
                strokeWidth: 4.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.driverLocation,
              width: 90,
              height: 52,
              child: const LocationMarker(
                label: 'Your location',
                color: AppColors.success,
              ),
            ),
            Marker(
              point: widget.destinationLocation,
              width: 80,
              height: 52,
              child: LocationMarker(
                label: widget.destinationLabel,
                color: AppColors.pink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
