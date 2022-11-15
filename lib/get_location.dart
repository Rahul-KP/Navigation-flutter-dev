import 'package:flutter/material.dart';
import 'map.dart';
import 'package:location/location.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

class _PosState extends State<Pos> {
  double lat = 0.0;
  double lon = 0.0;
  String latStr = '';
  String lonStr = '';

  void getPermissions() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _loc;

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

    _loc = await location.getLocation();
    setState(() {
      lat = _loc.latitude!;
      lon = _loc.longitude!;
      latStr = lat.toStringAsFixed(4);
      lonStr = lon.toStringAsFixed(4);
    });
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
            bottom: 15,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('Latitude  : $latStr'),
                Text('Longitude : $lonStr'),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() => getPermissions()),
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
