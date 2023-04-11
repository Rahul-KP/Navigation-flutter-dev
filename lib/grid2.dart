import 'dart:convert';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:what3words/what3words.dart';
import 'package:http/http.dart' as http;

class Grid {
  var _api;
  List<MapPolyline> lines = [];
  static Services sobj = Services();
  static GeoCoordinates? target = null;
  static bool choose2Squares = false;
  static MapPolyline? addSquare = null;
  static Routing obj = Routing();
  static MapPolyline? currentSquare = null;

  void init() {
    Services _sobj = Services();
    _api = What3WordsV3(_sobj.getSecret('what3words.api.key')!);
    print("Initialized W3W");
  }

  void _showGrid(List<Line> grid) async {
    List<GeoCoordinates> coordinates = [];
    double widthInPixels = 2;
    print(grid.length);

    for (Line element in grid) {
      coordinates.add(GeoCoordinates(element.start.lat, element.start.lng));
      coordinates.add(GeoCoordinates(element.end.lat, element.end.lng));
      MapPolyline polyline = MapPolyline(GeoPolyline(coordinates),
          widthInPixels, Color.fromARGB(255, 49, 214, 203));
      Services.mapController.mapScene.addMapPolyline(polyline);
      lines.add(polyline);

      coordinates.clear();
    }
  }

  void removeGrid() {
    for (MapPolyline element in lines) {
      print('rmoving!');
      Services.mapController.mapScene.removeMapPolyline(element);
    }
    lines.clear();
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

  void getGrid() async {
    GeoCoordinates NEC =
        Services.mapController.camera.boundingBox!.northEastCorner;
    GeoCoordinates SWC =
        Services.mapController.camera.boundingBox!.southWestCorner;
    GridSectionRequestBuilder gsrb = GridSectionRequestBuilder(
        _api,
        Coordinates(NEC.latitude, NEC.longitude),
        Coordinates(SWC.latitude, SWC.longitude));
    Response<GridSection> grid;
    grid = await gsrb.execute();
    Fluttertoast.showToast(msg: "Request successful grid2");
    print("Request successful grid2");

    if (grid.isSuccessful()) {
      _showGrid(grid.data()!.lines);
      Fluttertoast.showToast(msg: "Grid shown!");
    } else {
      print(grid.error()!.message);
    }

    // lat and long when screen is tapped
    Services.mapController.gestures.tapListener =
        TapListener((Point2D touchPoint) async {
      GeoCoordinates geoCoordinates =
          Services.mapController.viewToGeoCoordinates(touchPoint)!;
      Fluttertoast.showToast(msg: "Tapped!");
      print('Tap at: ' +
          geoCoordinates.latitude.toString() +
          '\n' +
          geoCoordinates.longitude.toString());
      // Fluttertoast.showToast(msg: 'Tap at: '+ geoCoordinates.latitude.toString()+'\n' +geoCoordinates.longitude.toString());

      var url = Uri.https('api.what3words.com', 'v3/convert-to-3wa', {
        'key': sobj.getSecret('what3words.api.key')!,
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
      }

      List<GeoCoordinates> coords = _getOtherCorners(
          parsed['square']['southwest']['lat'],
          parsed['square']['southwest']['lng'],
          parsed['square']['northeast']['lat'],
          parsed['square']['northeast']['lng']);

      if (choose2Squares) {
        if (addSquare != null) {
          Services.mapController.mapScene.removeMapPolyline(addSquare!);
        }
        addSquare = MapPolyline(GeoPolyline(coords), 5, Colors.orange.shade800);
        Services.mapController.mapScene.addMapPolyline(addSquare!);
        obj.addRoute(geoCoordinates, target!);
      } else {
        currentSquare =
            MapPolyline(GeoPolyline(coords), 5, Colors.red.shade700);
        target =
            GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude);
        Fluttertoast.showToast(msg: "redd marker!");

      }

      if (currentSquare != null) {
            Services.mapController.mapScene.removeMapPolyline(currentSquare!);
          }
          Services.mapController.mapScene.addMapPolyline(currentSquare!);

      
    });
  }
}
