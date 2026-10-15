import 'package:easy_localization/easy_localization.dart';
import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/constants/map_constants.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/presentation/extensions/location_coordinates_extension.dart';
import 'package:driver_app/features/location/presentation/widgets/location_marker.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
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

  final LocationCoordinates driverLocation;
  final LocationCoordinates destinationLocation;
  final String destinationLabel;
  final List<LocationCoordinates> routePoints;

  @override
  State<LocationMapSection> createState() => _LocationMapSectionState();
}

class _LocationMapSectionState extends State<LocationMapSection> {
  final MapController _mapController = MapController();
  bool _initialFitDone = false;

  LatLng get _driverLatLng => widget.driverLocation.toLatLng();
  LatLng get _destinationLatLng => widget.destinationLocation.toLatLng();
  List<LatLng> get _routeLatLngs =>
      widget.routePoints.map((p) => p.toLatLng()).toList();

  @override
  void didUpdateWidget(covariant LocationMapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverLocation != widget.driverLocation) {
      _fitBounds();
    }
  }

  void _fitBounds() {
    final bounds = LatLngBounds.fromPoints([
      _driverLatLng,
      _destinationLatLng,
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
        initialCenter: _driverLatLng,
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
          urlTemplate: MapConstants.tileLayerUrl,
          userAgentPackageName: MapConstants.packageName,
        ),
        if (widget.routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routeLatLngs,
                color: AppColors.pink,
                strokeWidth: 4.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: _driverLatLng,
              width: 100,
              height: 75,
              child: LocationMarker(
                label: LocaleKeys.orders_your_location.tr(),
                color: AppColors.success,
              ),
            ),
            Marker(
              point: _destinationLatLng,
              width: 100,
              height: 75,
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
