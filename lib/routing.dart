import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as here;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class Routing {
  late here.RoutingEngine _routingEngine;
  List<MapPolyline> _mapPolylines = [];
  late Services sobj;

  late DatabaseReference ref;
  // DatabaseReference ref = FirebaseDatabase.instance.ref('results');

  void initRoutingEngine(Services sobj) {
    try {
      _routingEngine = here.RoutingEngine();
      this.sobj = sobj;
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
    // ref.update({"0": routeDetails});
    Fluttertoast.showToast(msg: routeDetails);
  }

  showRouteOnMap(GeoPolyline routeGeoPolyline) {
    // Show route as polyline.
    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.fromARGB(160, 0, 144, 138));
    MapServices.mapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  Future<String> getRoute(
      String lat1, String lon1, String lat2, String lon2) async {
    await dotenv.load(fileName: "credentials.env");

    final response = await http.get(Uri.parse('http://' +
        dotenv.env["ip"]! +
        ':5566/?lat1=' +
        lat1 +
        '&lon1=' +
        lon1 +
        '&lat2=' +
        lat2 +
        '&lon2=' +
        lon2));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      print("Successful api call");
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      Fluttertoast.showToast(msg: 'Failed to get response');
      throw Exception('Failed to load album');
    }
  }

  void removeRoute() async {
    _mapPolylines.forEach((MapPolyline element) {
      MapServices.mapController.mapScene.removeMapPolyline(element);
    });
  }

  Future<void> addRoute(destinationGeoCoordinates) async {
    // GeoCoordinates startGeoCoordinates = await MapServices().getCurrentLoc();
    var startWaypoint = here.Waypoint.withDefaults(sobj.userLocation!);
    var destinationWaypoint =
        here.Waypoint.withDefaults(destinationGeoCoordinates);

    List<here.Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    if (_mapPolylines.isNotEmpty) this.removeRoute();

    _routingEngine.calculateCarRoute(waypoints, here.CarOptions(),
        (here.RoutingError? routingError, List<here.Route>? routeList) async {
      if (routingError == null) {
        // String? usertype = await sobj.getCred('usertype');
        String usertype = sobj.usertype;
        // When error is null, then the list guaranteed to be not null.
        here.Route route = routeList!.first;
        _showRouteDetails(route);
        showRouteOnMap(route.geometry);
        Fluttertoast.showToast(msg: usertype.toString());
        if (usertype == 'driver') {
          _broadcastRoute(route);
        }
      } else {
        var error = routingError.toString();
        Fluttertoast.showToast(msg: error);
      }
    });
  }

  //add route to database
  void _broadcastRoute(here.Route route) {
    List route_ = [];
    ref =
        FirebaseDatabase.instance.ref('Bookings/' + NavigationNotif.hashvalue);
    for (var element in route.geometry.vertices) {
      route_.add({"lat": element.latitude, "lon": element.longitude});
    }
    ref.update({'route': route_});
    var box = Hive.openBox('routes');
    box.then((value) => value.put('route', route_));
    Fluttertoast.showToast(msg: "path now put to firebase rtdb");
  }
}
