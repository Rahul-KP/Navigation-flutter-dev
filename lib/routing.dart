import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as here;

class Routing {
  late here.RoutingEngine _routingEngine;
  List<MapPolyline> _mapPolylines = [];

  DatabaseReference ref =
      FirebaseDatabase.instance.ref('Drivers/' + Services.username);

  void initRoutingEngine() {
    try {
      _routingEngine = here.RoutingEngine();
    } on InstantiationException {
      throw ("Initialization of RoutingEngine failed.");
    }
  }

  String _formatTime(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    return '$hours:$minutes min';
  }

  String _formatLength(int meters) {
    int kilometers = meters ~/ 1000;
    int remainingMeters = meters % 1000;

    return '$kilometers.$remainingMeters km';
  }

  void _showRouteDetails(here.Route route) {
    int estimatedTravelTimeInSeconds = route.duration.inSeconds;
    int lengthInMeters = route.lengthInMeters;

    String routeDetails = 'Travel Time: ' +
        _formatTime(estimatedTravelTimeInSeconds) +
        ', Length: ' +
        _formatLength(lengthInMeters);
    Fluttertoast.showToast(msg: routeDetails);
  }

  showRouteOnMap(GeoPolyline routeGeoPolyline) {
    // Show route as polyline.
    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));
    Services.mapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<void> addRoute(GeoCoordinates startGeoCoordinates,
      GeoCoordinates destinationGeoCoordinates) async {
    // _showRouteDetails(route);
    // showRouteOnMap(route.geometry);
    // if (Services.usertype == 'driver') {
    //   _broadcastRoute(route);
    // }
    startGeoCoordinates.latitude;
    
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      Services.mapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  //add route to database
  void _broadcastRoute(here.Route route) {
    List route_ = [];
    for (var element in route.geometry.vertices) {
      route_.add({"lat": element.latitude, "lon": element.longitude});
    }
    ref.update({'route': route_});
    Services.pathToBeShared = route_;
  }
}
