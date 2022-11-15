import 'package:flutter/material.dart';
import 'map.dart';
import 'package:location/location.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

class _PosState extends State<Pos> {
  late Location location;
  late LocationData _locationData;

  void getPermissions() async {
    location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Map(),
          Positioned(
            bottom: 0,
            left: 0,
            child: Column(
              children: [
                Text('Latitude  :$_locationData.latitude.toStringAsFixed(4)'),
                Text("Longitude :$_locationData.longitude.toStringAsFixed(4)"),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() => setState(() async {
                _locationData = await location.getLocation();
              })),
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.blueAccent,
          )),
    );
  }
}
