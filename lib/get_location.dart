import 'package:flutter/material.dart';
import 'map.dart';
import 'package:location/location.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

mixin locationInfo {
  static double lat = 0.0;
  static double lon = 0.0;
}

class _PosState extends State<Pos> with locationInfo {
  // double lat = 0.0;
  // double lon = 0.0;
  String latStr = '';
  String lonStr = '';
  late Stream<LocationData> _locationData;

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
    // _locationData = location.onLocationChanged;
    setState(() {
      locationInfo.lat = _loc.latitude!;
      locationInfo.lon = _loc.longitude!;
      // LocationData tempLoc = await _locationData.first;
      // lat = tempLoc.latitude!;
      // lon = tempLoc.longitude!;
      latStr = locationInfo.lat.toStringAsFixed(4);
      lonStr = locationInfo.lon.toStringAsFixed(4);
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
          Map(),
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
