import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:location/location.dart';

class SharedData {
  static double lat = 0.0;
  static double lon = 0.0;
  static late Stream<LocationData> locationData;
  static late MapmyIndiaMapController mapController;
}