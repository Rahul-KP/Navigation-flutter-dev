import 'dart:math';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:location/location.dart';
import 'package:here_sdk/routing.dart' as here;
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

  static core.GeoCoordinates _createRandomGeoCoordinatesInViewport() {
    core.GeoBox? geoBox = SharedData.mapController.camera.boundingBox;
    if (geoBox == null) {
      // Happens only when map is not fully covering the viewport as the map is tilted.
      print(
          "The map view is tilted, falling back to fixed destination coordinate.");
      return core.GeoCoordinates(52.530932, 13.384915);
    }

    core.GeoCoordinates northEast = geoBox.northEastCorner;
    core.GeoCoordinates southWest = geoBox.southWestCorner;

    double minLat = southWest.latitude;
    double maxLat = northEast.latitude;
    double lat = _getRandom(minLat, maxLat);

    double minLon = southWest.longitude;
    double maxLon = northEast.longitude;
    double lon = _getRandom(minLon, maxLon);

    return core.GeoCoordinates(lat, lon);
  }

  static double _getRandom(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  static Future<void> addRoute(RoutingEngine _routingEngine) async {
    var startGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var destinationGeoCoordinates = _createRandomGeoCoordinatesInViewport();
    var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(destinationGeoCoordinates);

    List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    _routingEngine.calculateCarRoute(waypoints, CarOptions(),
        (RoutingError? routingError, List<here.Route>? routeList) async {
      if (routingError == null) {
        // When error is null, it is guaranteed that the list is not empty.
        here.Route route = routeList!.first;
        // _showRouteDetails(route);
        _showRouteOnMap(route);
        // _logRouteViolations(route);
      } else {
        var error = routingError.toString();
        // _showDialog('Error', 'Error while calculating a route: $error');
      }
    });
  }

  static void _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    core.GeoPolyline routeGeoPolyline = route.geometry;
    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));
    SharedData.mapController.mapScene.addMapPolyline(routeMapPolyline);
  }

  static void plot() {
    try {
      SharedData.routingEngine = RoutingEngine();
    } on InstantiationException {
      throw ("Initialization of RoutingEngine failed.");
    }
    addRoute(SharedData.routingEngine);
  }

  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.camera.lookAtPoint(core.GeoCoordinates(ld.latitude!, ld.longitude!));
  }

  static void search() async {
    // Code to implement search functionality
  }
}
