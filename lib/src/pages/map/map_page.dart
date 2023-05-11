import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constants/asset.dart';
import '../../services/common.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const CameraPosition _initMap = CameraPosition(
    target: LatLng(13.7462463, 100.5325515),
    zoom: 20,
  );

  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationData>? _locationSubscription;
  final _locationService = Location();
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};

  final List<LatLng> _dummyLatLng = [
    LatLng(13.729336912458525, 100.57422749698162),
    LatLng(13.724325366482798, 100.58511726558208),
    LatLng(13.716931129483003, 100.57489234954119),
    LatLng(13.724794053328308, 100.56783076375723),
  ];

  @override
  void initState() {
    super.initState();
    _buildSingleMarker(position: _initMap.target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Map'), actions: [
          IconButton(
              onPressed: () {
                _controller.future.then(
                  (value) => value.animateCamera(
                    CameraUpdate.newLatLngZoom(_initMap.target, 15),
                  ),
                );
              },
              icon: Icon(Icons.pin_drop)),
        ]),
        body: Column(
          children: [
            Image.asset(Asset.logoImage),
            Expanded(
              child: GoogleMap(
                  mapType: MapType.normal,
                  trafficEnabled: true,
                  markers: _markers,
                  polygons: _polygons,
                  initialCameraPosition: _initMap,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    // _dummyLocation();
                  }),
            )
          ],
        ));
  }

 _buildPolygon() {
    final polygon = Polygon(
      polygonId: PolygonId("1"),
      consumeTapEvents: true,
      points: _dummyLatLng,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(1),
    );

    _polygons.add(polygon);
    setState(() {});
  }
  Future<void> _buildSingleMarker({required LatLng position}) async {
    final Uint8List markerIcon = await getBytesFromAsset(Asset.pinBikerImage, width: 150);
    final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(markerIcon);
    final marker = Marker(markerId: MarkerId(jsonEncode(position)), icon: bitmap, position: position);
    _markers.add(marker);
    setState(() {});
  }
}