import 'dart:convert';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:AmbiNav/starter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:what3words/what3words.dart';
import 'package:http/http.dart' as http;

class Grid {
  var _api;
  List<MapPolyline> lines = [];
  Services sobj = Services();
  static GeoCoordinates? target = null;
  static bool marked = false;
  static MapPolyline? addSquare = null;
  static Routing obj = Routing();
  static MapPolyline? currentSquare = null;
  static MapPolyline? prevSquare = null;
  static GeoCoordinates source = GeoCoordinates(12.916734, 77.673736);
  static bool choose2Squares = false;
  bool isDisplayed = false;
  bool isBooking = false;

  Grid() {
    Services _sobj = Services();
    _api = What3WordsV3(Starter().getSecret('what3words.api.key')!);
    print("Initialized W3W");
  }

  void _convertGrid(List<Line> grid) {
    List<GeoCoordinates> coordinates = [];
    double widthInPixels = 2;

    print(grid.length);

    for (Line element in grid) {
      coordinates.add(GeoCoordinates(element.start.lat, element.start.lng));
      coordinates.add(GeoCoordinates(element.end.lat, element.end.lng));
      MapPolyline polyline = MapPolyline(GeoPolyline(coordinates),
          widthInPixels, Color.fromARGB(255, 49, 214, 203));
      lines.add(polyline);

      coordinates.clear();
    }
  }

  void _showGrid() {
    for (MapPolyline polyline in lines) {
      MapServices.mapController.mapScene.addMapPolyline(polyline);
    }
    isDisplayed = true;
  }

  Future<void> removeGrid() async {
    for (MapPolyline element in lines) {
      print('removing!');
      MapServices.mapController.mapScene.removeMapPolyline(element);
    }
    // Services.mapController.mapScene.removeMapPolyline(polyline);
    lines.clear();
    isDisplayed = false;
    MapServices.mapController.gestures.tapListener = null;
    if(currentSquare != null) MapServices.mapController.mapScene.removeMapPolyline(currentSquare!);
  }

  static List<GeoCoordinates> _getOtherCorners(
      double swLat, double swLng, double neLat, double neLng) {
    List<List<double>> otherCorners = List.generate(4, (_) => [0.0, 0.0]);

    double width = neLng - swLng;
    double height = neLat - swLat;

    otherCorners[0][0] = swLat;
    otherCorners[0][1] = swLng;

    otherCorners[1][0] = swLat;
    otherCorners[1][1] = swLng + width;

    otherCorners[2][0] = swLat + height;
    otherCorners[2][1] = swLng + width;

    otherCorners[3][0] = swLat + height;
    otherCorners[3][1] = swLng;

    List<GeoCoordinates> coords = [];
    for (List<double> pair in otherCorners) {
      coords.add(GeoCoordinates(pair[0], pair[1]));
    }
    coords.add(coords.first);

    return coords;
  }

  bool markerState() {
    if (marked) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getGrid() async {
    GeoCoordinates NEC =
        MapServices.mapController.camera.boundingBox!.northEastCorner;
    GeoCoordinates SWC =
        MapServices.mapController.camera.boundingBox!.southWestCorner;
    GridSectionRequestBuilder gsrb = GridSectionRequestBuilder(
        _api,
        Coordinates(NEC.latitude, NEC.longitude),
        Coordinates(SWC.latitude, SWC.longitude));
    Response<GridSection> grid;
    grid = await gsrb.execute();
    print("Request successful grid2");

    if (grid.isSuccessful()) {
      _convertGrid(grid.data()!.lines);
      _showGrid();
    } else {
      print(grid.error()!.message);
    }

    // lat and long when screen is tapped
    MapServices.mapController.gestures.tapListener =
        TapListener((Point2D touchPoint) async {
      GeoCoordinates geoCoordinates =
          MapServices.mapController.viewToGeoCoordinates(touchPoint)!;
      marked = markerState();
      print('Tap at: ' +
          geoCoordinates.latitude.toString() +
          '\n' +
          geoCoordinates.longitude.toString());
      // Fluttertoast.showToast(msg: 'Tap at: '+ geoCoordinates.latitude.toString()+'\n' +geoCoordinates.longitude.toString());
      var url = Uri.https('api.what3words.com', 'v3/convert-to-3wa', {
        'key': Starter().getSecret('what3words.api.key')!,
        'coordinates': geoCoordinates.latitude.toString() +
            ',' +
            geoCoordinates.longitude.toString(),
      });

      var response = await http.get(url);

      Map<String, dynamic> parsed =
          jsonDecode(response.body).cast<String, dynamic>();

      if (parsed.containsKey('words')) {
        print('3word request successful');
        Fluttertoast.showToast(msg: parsed['words']);
        print(parsed['words']);
        if (isBooking) {
          var box = Hive.openBox('booking');
          box.then((value_) {
            value_.put('lat', geoCoordinates.latitude);
            value_.put('lon', geoCoordinates.longitude);
          });
        }
      }

      List<GeoCoordinates> coords = _getOtherCorners(
          parsed['square']['southwest']['lat'],
          parsed['square']['southwest']['lng'],
          parsed['square']['northeast']['lat'],
          parsed['square']['northeast']['lng']);

      if (!marked) {
        // Fluttertoast.showToast(msg: "removing the marker");
        MapServices.mapController.mapScene.removeMapPolyline(currentSquare!);
        currentSquare = null;
        marked = markerState();
      }
      currentSquare = MapPolyline(GeoPolyline(coords), 5, Colors.red.shade700);
      target =
          GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude);
      // Fluttertoast.showToast(msg: "redd marker!");

      if (currentSquare != null) {
        MapServices.mapController.mapScene.removeMapPolyline(currentSquare!);
      }
      MapServices.mapController.mapScene.addMapPolyline(currentSquare!);
    });
  }
}
