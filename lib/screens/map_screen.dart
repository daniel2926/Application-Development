import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/constants/urls.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final GeoPoint location;

  const MapScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    LatLng latLng = LatLng(location.latitude, location.longitude);

    return Scaffold(
      appBar: AppBar(
        shape: const Border(bottom: BorderSide(color: inActive, width: 0.5)),
        centerTitle: true,
        title: Image.network(
          logoUrl,
          height: 28,
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: latLng,
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
