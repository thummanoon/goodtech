import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WidgetGoogleMap extends StatelessWidget {
  const WidgetGoogleMap({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      markers: <Marker>[
        Marker(
          markerId: MarkerId('UserID'),
          position: LatLng(lat, lng), infoWindow: InfoWindow(title: 'คุณอยู่ที่นี่'),
        ),
      ].toSet(),
    );
  }
}
