import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:location/location.dart';
import 'package:here_sdk/core.dart' as here_core;

class MapServices {
  static late HereMapController mapController;

  static late LocationIndicator locationIndicator;

  void setTapGestureHandler(TapListener listener) {
    MapServices.mapController.gestures.tapListener = listener;
  }

  void goToUserLoc() async {
    // Code to move the camera to user's current location
    LocationData temp = await Location().getLocation();
    here_core.GeoCoordinates userLocation =
        here_core.GeoCoordinates(temp.latitude!, temp.longitude!);
    MapServices.mapController.camera.lookAtPoint(userLocation);
  }

  void clearMapMarkers(List<MapMarker> mapMarkerList) {
    mapMarkerList.forEach((mapMarker) {
      MapServices.mapController.mapScene.removeMapMarker(mapMarker);
    });
    mapMarkerList.clear();
  }

  void clearMapPolylines(List<MapPolyline> mapPolylines) {
    for (var mapPolyline in mapPolylines) {
      MapServices.mapController.mapScene.removeMapPolyline(mapPolyline);
    }
    mapPolylines.clear();
  }

  Future<here_core.GeoCoordinates> getCurrentLoc() async {
    LocationData temp = await Location().getLocation();
    return here_core.GeoCoordinates(temp.latitude!, temp.longitude!);
  }
}
