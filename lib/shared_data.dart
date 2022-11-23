import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:location/location.dart';

class SharedData {
  // static late LatLng userLoc; //user's location
  static late Stream<LocationData> locationData; // user's location
  static late MapmyIndiaMapController mapController;
}