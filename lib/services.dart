import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/mapview.dart';
import 'package:location/location.dart';

class Services {
  static late HereMapController mapController;
  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  static late var setStateOverlay;
  static late String usertype;
  static late String username;
  static late BuildContext mapContext;
  static late core.GeoCoordinates userLocation; // user's location
  static LocationIndicator locationIndicator = LocationIndicator();
  static DatabaseReference ref = FirebaseDatabase.instance.ref('routes');
  static DatabaseReference currentLocRef =
      FirebaseDatabase.instance.ref('current_loc/' + username);
  static late DataSnapshot formDetails;
  static bool flag = false;

  static void setLoc() async {
    Location location = await Location();
    location.changeSettings(accuracy: LocationAccuracy.high,interval: 5000,distanceFilter: 1);
    location.onLocationChanged.listen((LocationData currentLocation) {
      userLocation = core.GeoCoordinates(
          currentLocation.latitude!, currentLocation.longitude!);
      flag = true;
      core.Location cameraLoc_ = core.Location.withCoordinates(userLocation);
      cameraLoc_.bearingInDegrees = currentLocation
          .heading; // Degrees of the horizontal direction the user is facing
          print("degrees"+cameraLoc_.bearingInDegrees.toString());
      locationIndicator.updateLocation(cameraLoc_);

      if (usertype == 'driver') {
        // broadcast the location if the ambulance driver is using the app
        _broadcastLoc();
      }
    });
  }

  static void _broadcastLoc() async {
    currentLocRef
        .set({'lat': userLocation.latitude, 'lon': userLocation.longitude});
  }

  static Future<void> getPermissions() async {
    Location location = Location();

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
    LocationData temp = await location.getLocation();
    Services.userLocation = core.GeoCoordinates(temp.latitude!,temp.longitude!);
  }
}
