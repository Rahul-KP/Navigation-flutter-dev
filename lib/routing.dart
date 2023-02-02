import 'package:AmbiNav/RDP.dart';
import 'package:AmbiNav/services.dart';
import 'package:AmbiNav/what3words_impl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as here;

class Routing {
  late here.RoutingEngine _routingEngine;
  List<MapPolyline> _mapPolylines = [];
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('routes/' + Services.username);

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

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = route.geometry;
    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));
    Services.mapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<void> addRoute(startGeoCoordinates, destinationGeoCoordinates) async {
    var startWaypoint = here.Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint =
        here.Waypoint.withDefaults(destinationGeoCoordinates);

    List<here.Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    _routingEngine.calculateCarRoute(waypoints, here.CarOptions(),
        (here.RoutingError? routingError, List<here.Route>? routeList) async {
      if (routingError == null) {
        // When error is null, then the list guaranteed to be not null.
        here.Route route = routeList!.first;
        _showRouteDetails(route);
        // _showRouteOnMap(route);
        if (Services.usertype == 'driver') {
          _broadcastRoute(route);
        }
      } else {
        var error = routingError.toString();
        Fluttertoast.showToast(msg: error);
      }
    });
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      Services.mapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  Future<Uint8List> _loadFileAsUint8List(String assetPathToFile) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load(assetPathToFile);
    return Uint8List.view(fileData.buffer);
  }

  void _broadcastRoute(here.Route route) async {
    W3Words obj = W3Words();
    await obj.init();
    List route_ = [];
    MapImage mapImage;
    Uint8List imagePixelData = await _loadFileAsUint8List('assets/poi.png');
    mapImage =
        MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    for (var element in route.geometry.vertices) {
      Services.mapController.mapScene
          .addMapMarker(MapMarker(element, mapImage));
      // String wordTriplet = await obj.convertToWords(element);
      route_.add({"lat": element.latitude, "lon": element.longitude});
      // route_.add(wordTriplet);
    }
    Fluttertoast.showToast(
        msg: 'Original length: ' +
            route_.length.toString() +
            'New: ' +
            RDP.simplifyRDP(route.geometry.vertices, 5).length.toString());
    // print(FourierSeries.toFourierSeriesFunction(route.geometry.vertices, 100));
    ref.update({'route': route_.toString()});
  }
}
