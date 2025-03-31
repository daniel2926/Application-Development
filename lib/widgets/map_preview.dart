import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_pad_1/screens/map_screen.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  final GeoPoint location;

  const MapPreview({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    LatLng latLng = LatLng(location.latitude, location.longitude);
    String mapImageUrl =
        "https://maps.googleapis.com/maps/api/staticmap?center=${latLng.latitude},${latLng.longitude}&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7C${latLng.latitude},${latLng.longitude}&key=YOUR_GOOGLE_MAPS_API_KEY";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(location: location),
          ),
        );
      },
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: AbsorbPointer(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: latLng,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    tileProvider: CancellableNetworkTileProvider(),
                    retinaMode: RetinaMode.isHighDensity(context),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: latLng,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
