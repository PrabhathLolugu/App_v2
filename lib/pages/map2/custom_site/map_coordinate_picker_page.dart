import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/i18n/strings.g.dart';

class MapCoordinatePickerPage extends StatefulWidget {
  const MapCoordinatePickerPage({
    super.key,
    this.initialCoordinate,
  });

  final LatLng? initialCoordinate;

  @override
  State<MapCoordinatePickerPage> createState() => _MapCoordinatePickerPageState();
}

class _MapCoordinatePickerPageState extends State<MapCoordinatePickerPage> {
  static const LatLng _indiaCenter = LatLng(20.5937, 78.9629);
  LatLng? _selectedCoordinate;

  @override
  void initState() {
    super.initState();
    _selectedCoordinate = widget.initialCoordinate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translations.of(context).map.pickLocationOnMap)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedCoordinate ?? _indiaCenter,
              zoom: _selectedCoordinate == null ? 4.8 : 13,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(4.0, 18.0),
            markers: _selectedCoordinate == null
                ? const <Marker>{}
                : {
                    Marker(
                      markerId: const MarkerId('picked-coordinate'),
                      position: _selectedCoordinate!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                    ),
                  },
            onTap: (latLng) => setState(() => _selectedCoordinate = latLng),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: FilledButton.icon(
                onPressed: _selectedCoordinate == null
                    ? null
                    : () => Navigator.of(context).pop(_selectedCoordinate),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  _selectedCoordinate == null
                      ? 'Tap on map to select coordinates'
                      : 'Use selected location',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
