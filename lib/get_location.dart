import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'shared_data.dart';
import 'map.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:location/location.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

class _PosState extends State<Pos> {
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
    SharedData.locationData = location.onLocationChanged;
    // function();
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(ld.latitude!,ld.longitude!), 18));
  }

  void function () async {
    await for(LocationData ld in SharedData.locationData) {
      SharedData.mapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(ld.latitude!,ld.longitude!), 14));
      Fluttertoast.showToast(
        msg: "Location Data updated!",
        backgroundColor: Colors.amber);
    }
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() => getPermissions()), // needs to change
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
