import 'package:AmbiNav/map_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:location/location.dart';

class Services {
  late String username;
  late String usertype;
  DatabaseReference? currentLocRef = null;
  late core.GeoCoordinates userLocation;

  Future<String?> getCred(String key) {
    var box = Hive.openBox('creds');
    box.then((value) {
      return value.get(key);
    });
    return Future<Null>.value(null);
  }

  void setCred(String key, String value) {
    var box = Hive.openBox('creds');
    box.then((value_) {
      value_.put(key, value);
    });
  }

  void logout() async {
    Hive.deleteBoxFromDisk('creds');
    SharedPreferences login = await SharedPreferences.getInstance();
    login.setBool('login', true);
  }

  void bookAmbulance() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    var box = await Hive.openBox('booking');
    //call to hashing function
    Fluttertoast.showToast(msg: "Booking Successful!");
    ref.update({
      box.get('hash'): {
        "patient_name": box.get('name'),
        "age": box.get('age'),
        "preferred_hospital": box.get('preferred_hosp'),
        "gender": box.get('gender'),
        "user_location": {
          "lat": box.get('lat'),
          "lon": box.get('lon'),
        }
      }
    });
  }

  void streamLoc() async {
    Location location = await Location();
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 1);
    location.onLocationChanged.listen((LocationData currentLocation) {
      userLocation = core.GeoCoordinates(
          currentLocation.latitude!, currentLocation.longitude!);
      core.Location cameraLoc_ = core.Location.withCoordinates(userLocation);
      cameraLoc_.bearingInDegrees = currentLocation
          .heading; // Degrees of the horizontal direction the user is facing
      print("degrees" + cameraLoc_.bearingInDegrees.toString());
      MapServices.locationIndicator.updateLocation(cameraLoc_);

      if (this.usertype == 'driver') {
        // broadcast the location if the ambulance driver is using the app
        _broadcastLoc();
      }
    });
  }

  void _broadcastLoc() async {
    if (currentLocRef == null) {
      currentLocRef =
          FirebaseDatabase.instance.ref('current_loc/' + this.username);
    }
    currentLocRef!
        .set({'lat': userLocation.latitude, 'lon': userLocation.longitude});
  }

  void goToUserLoc() async {
    MapServices.mapController.camera.lookAtPoint(userLocation);
  }
}
