// Code for map widget
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'services.dart';
// import 'main.dart' as mm;

class MapWidget extends StatelessWidget {
  MapWidget({required Services sobj});

  @override
  Widget build(BuildContext context) {
    return HereMap(onMapCreated: _onMapCreated);
  }

  void _onMapCreated(HereMapController hereMapController) async {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }
      MapServices.mapController = hereMapController;
      const double distanceToEarthInMeters = 4000;
      MapMeasure mapMeasureZoom =
          MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);

      MapServices().getCurrentLoc().then((value) {
        hereMapController.camera.lookAtPointWithMeasure(value, mapMeasureZoom);
        _addLocationIndicator(
            value, LocationIndicatorIndicatorStyle.navigation);
      });
    });
  }

  void _addLocationIndicator(GeoCoordinates geoCoordinates,
      LocationIndicatorIndicatorStyle indicatorStyle) async {
    // mm.sobj.locationIndicator.locationIndicatorStyle = indicatorStyle;
    MapServices.locationIndicator = LocationIndicator();
    MapServices.locationIndicator.locationIndicatorStyle = indicatorStyle;

    // A LocationIndicator is intended to mark the user's current location,
    // including a bearing direction.
    // For testing purposes, we create a Location object. Usually, you may want to get this from
    // a GPS sensor instead.
    Location location = Location.withCoordinates(GeoCoordinates(12.9716, 77.5946));
    location.horizontalAccuracyInMeters = 1.0;
    // location.time = DateTime.now();
    // // location.bearingInDegrees = _getRandom(0, 360);

    // mm.sobj.locationIndicator.updateLocation(location);
    MapServices.locationIndicator.updateLocation(location);
    sobj.streamLoc();
    // A LocationIndicator listens to the lifecycle of the map view,
    // therefore, for example, it will get destroyed when the map view gets destroyed.
    MapServices.mapController.addLifecycleListener(MapServices.locationIndicator);
  }
}
