import 'dart:async';
import 'package:AmbiNav/search_res.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/mapview.dart';
import 'package:location/location.dart';

 class Services {
  static late HereMapController mapController;
  static SearchRes search = SearchRes();
  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  static late var setStateOverlay;
  late String usertype;
  late String username; 
  late BuildContext mapContext;
  late core.GeoCoordinates userLocation; // user's location
  late LocationIndicator locationIndicator;
  // DatabaseReference ref = FirebaseDatabase.instance.ref('routes');
  //this current_loc is used for driver's current location
  //NOTE: not setting this in  All Drivers key of rtdb because this has to be used by IoT device
  //and the IoT device is slow in handling nested data
  late DatabaseReference currentLocRef ;
  //a field to note which driver has accepted which patient and to broadcast route i.e pathToBeShared field
  late DatabaseReference driverProfiles;
  //a listen flag for ambulance driver to not listen to bookings once a patient has been accepted
  //after the trip is complete , resubscribe to bookings listener
  late StreamSubscription<DatabaseEvent> listen;
  late DataSnapshot formDetails;
  late List pathToBeShared;


  Future<void> loadCreds() async {
    //loading the .env file
    await dotenv.load(fileName: "credentials.env");
  }

  Future<void> postLogin() async {
    currentLocRef = FirebaseDatabase.instance.ref('current_loc/' + Services().username);
    this.setLoc(); // start streaming the location
  }

  String? getSecret(String key) {
    return dotenv.env[key];
    //here.access.key.id
  }

  void setLoc() async {
    Location location = await Location();
    location.changeSettings(accuracy: LocationAccuracy.high,interval: 5000,distanceFilter: 1);
    location.onLocationChanged.listen((LocationData currentLocation) {
      userLocation = core.GeoCoordinates(
          currentLocation.latitude!, currentLocation.longitude!);
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

  void _broadcastLoc() async {

    currentLocRef
        .set({'lat': userLocation.latitude, 'lon': userLocation.longitude});
  }

  Future<void> getPermissions() async {
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
   userLocation = core.GeoCoordinates(temp.latitude!,temp.longitude!);
  }
}
