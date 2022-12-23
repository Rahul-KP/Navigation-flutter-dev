// Code for map widget
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'shared_data.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HERE SDK for Flutter - Hello Map!',
      home: HereMap(onMapCreated: _onMapCreated),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 8000;
      MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
      hereMapController.camera.lookAtPointWithMeasure(GeoCoordinates(52.530932, 13.384915), mapMeasureZoom);
    });

    SharedData.mapController = hereMapController;
    _addLocationIndicator(GeoCoordinates(52.530932, 13.384915),LocationIndicatorIndicatorStyle.navigation);
  }

  void _addLocationIndicator(GeoCoordinates geoCoordinates, LocationIndicatorIndicatorStyle indicatorStyle) {
    LocationIndicator locationIndicator = LocationIndicator();
    locationIndicator.locationIndicatorStyle = indicatorStyle;

    // A LocationIndicator is intended to mark the user's current location,
    // including a bearing direction.
    // For testing purposes, we create a Location object. Usually, you may want to get this from
    // a GPS sensor instead.
    Location location = Location.withCoordinates(geoCoordinates);
    location.time = DateTime.now();
    // location.bearingInDegrees = _getRandom(0, 360);

    locationIndicator.updateLocation(location);

    // A LocationIndicator listens to the lifecycle of the map view,
    // therefore, for example, it will get destroyed when the map view gets destroyed.
    SharedData.mapController.addLifecycleListener(locationIndicator);
  }
}