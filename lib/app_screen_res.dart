import 'package:here_sdk/core.dart' as core;
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
  }

  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.camera
        .lookAtPoint(core.GeoCoordinates(ld.latitude!, ld.longitude!));
  }

  static void search() async {
    // Code to implement search functionality
  }
}
