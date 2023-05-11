import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maptoolkit;
import 'package:url_launcher/url_launcher.dart';

import '../../app.dart';
import '../../constants/asset.dart';
import '../../services/common.dart';
import '../../widgets/custom_flushbar.dart';

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
    _buildPolygon();
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
                    _animateToPolygon();
                    // _dummyLocation();
                  }),
            )
          ],
        ));
  }

  Future<void> _animateToPolygon() async {
    await Future.delayed(const Duration(seconds: 1));
    for (var latLng in _dummyLatLng) {
      await _buildSingleMarker(position: latLng);
    }

    // _dummyLatLng.forEach((latLng) => _buildSingleMarker(position: latLng));

    final bound = _boundsFromLatLngList(_dummyLatLng);
    _controller.future.then((map) => map.moveCamera(CameraUpdate.newLatLngBounds(bound, 50)));
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1 = 0;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  _buildPolygon() {
    final polygon = Polygon(
      polygonId: PolygonId("1"),
      consumeTapEvents: true,
      onTap: () {
        final mapToolkitLatLng = _dummyLatLng.map((e) {
          return maptoolkit.LatLng(e.latitude, e.longitude);
        }).toList();

        // https://www.mapdevelopers.com/area_finder.php
        // https://www.inchcalculator.com/convert/square-meter-to-square-kilometer/
        final meterArea = maptoolkit.SphericalUtil.computeArea(mapToolkitLatLng);
        final kmArea = formatCurrency.format(meterArea / (1000000));
        CustomFlushbar.showSuccess(navigatorState.currentContext!, message: "Area: $kmArea ²Km");
      },
      points: _dummyLatLng,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    );

    _polygons.add(polygon);
    setState(() {});
  }

  String formatPosition(LatLng pos) {
    final lat = formatCurrency.format(pos.latitude);
    final lng = formatCurrency.format(pos.longitude);
    return ": $lat, $lng";
  }

  void _launchMaps({required double lat, required double lng}) async {
    final parameter = '?z=16&q=$lat,$lng';

    if (Platform.isIOS) {
      final googleMap = Uri.parse('comgooglemaps://' + parameter);
      final appleMap = Uri.parse('https://maps.apple.com/' + parameter);
      if (await canLaunchUrl(googleMap)) {
        await launchUrl(googleMap);
        return;
      }
      if (await canLaunchUrl(appleMap)) {
        await launchUrl(appleMap);
        return;
      }
    } else {
      final googleMapURL = Uri.parse('https://maps.google.com/' + parameter);
      if (await canLaunchUrl(googleMapURL)) {
        await launchUrl(googleMapURL);
        return;
      }
    }
    throw 'Could not launch url';
  }

  Future<void> _buildSingleMarker({required LatLng position}) async {
    final Uint8List markerIcon = await getBytesFromAsset(Asset.pinBikerImage, width: 150);
    final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(markerIcon);
    final marker = Marker(
      markerId: MarkerId(jsonEncode(position)),
      infoWindow: InfoWindow(
        title: formatPosition(position),
        snippet: "",
        onTap: () => _launchMaps(lat: position.latitude, lng: position.longitude),
      ),
      icon: bitmap,
      position: position,
    );
    _markers.add(marker);
    setState(() {});
  }
}