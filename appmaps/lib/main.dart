import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/icon_marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(
      GoogleMapController controller, LatLng pinPosition) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();

      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
      // final marker = Marker(
      //   markerId: MarkerId('office.name'),
      //   position: pinPosition,
      //   icon: pinLocationIcon,
      //   infoWindow: InfoWindow(
      //     title: 'office.name',
      //     snippet: 'office.address',
      //   ),
      // );
      // _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = const LatLng(37.3797536, -122.1017334);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.purple,
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          onMapCreated: (_) {
            _onMapCreated(_, pinPosition);
          },
          initialCameraPosition: CameraPosition(
            //target: LatLng(0, 0),
            target: pinPosition,
            // bearing: 30,
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}