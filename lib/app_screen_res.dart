import 'package:location/location.dart';
import 'shared_data.dart';

class MapScreenRes {
  static void getPermissions() async {
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
    // Stream of data containing user's current location
    SharedData.locationData = location.onLocationChanged;

    // Code to move the camera to user's current location
    
  }

  static void gotoUserLoc() async {
    // Code to move the camera to user's current location
  }

  static void search() async {
    // Code to implement search functionality
  }
}