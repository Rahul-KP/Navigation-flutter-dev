// Code for map widget
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'services.dart';
import 'main.dart' as mm;

class MapWidget extends StatelessWidget {
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

      const double distanceToEarthInMeters = 4000;
      MapMeasure mapMeasureZoom =
          MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);

      hereMapController.camera
          .lookAtPointWithMeasure(mm.sobj.userLocation, mapMeasureZoom);
    });

    Services.mapController = hereMapController;
    _addLocationIndicator(
        mm.sobj.userLocation, LocationIndicatorIndicatorStyle.navigation);
  }

  void _addLocationIndicator(GeoCoordinates geoCoordinates,
      LocationIndicatorIndicatorStyle indicatorStyle) {
    // mm.sobj.locationIndicator.locationIndicatorStyle = indicatorStyle;
    Services.locationIndicator.locationIndicatorStyle = indicatorStyle;


    // A LocationIndicator is intended to mark the user's current location,
    // including a bearing direction.
    // For testing purposes, we create a Location object. Usually, you may want to get this from
    // a GPS sensor instead.
    Location location = Location.withCoordinates(mm.sobj.userLocation);
    location.horizontalAccuracyInMeters = 1.0;
    // location.time = DateTime.now();
    // // location.bearingInDegrees = _getRandom(0, 360);

    // mm.sobj.locationIndicator.updateLocation(location);
    Services.locationIndicator.updateLocation(location);


    // A LocationIndicator listens to the lifecycle of the map view,
    // therefore, for example, it will get destroyed when the map view gets destroyed.
    Services.mapController.addLifecycleListener(Services.locationIndicator);
  }
}
