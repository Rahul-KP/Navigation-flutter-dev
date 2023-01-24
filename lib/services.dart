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
  static DatabaseReference ref = FirebaseDatabase.instance.ref();
  static late DataSnapshot formDetails;

  static void setLoc() async {
    await for (final location_ in Location().onLocationChanged) {
      // Stream of data containing user's current location
      userLocation =
          core.GeoCoordinates(location_.latitude!, location_.longitude!);
      
      core.Location cameraLoc_ = core.Location.withCoordinates(userLocation);
      cameraLoc_.bearingInDegrees = location_.heading; // Degrees of the horizontal direction the user is facing
      locationIndicator.updateLocation(cameraLoc_);
      
      if (usertype == 'driver') { // broadcast the location if the ambulance driver is using the app
        _broadcastLoc();
      }
    }
  }

  static void _broadcastLoc() async {
    ref
        .child('routes/' + username + '/current_loc')
        .ref
        .update({'lat': userLocation.latitude, 'lon': userLocation.longitude});
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
  }
}
