import 'dart:convert';
import 'dart:math';
import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:http/http.dart' as http;

class Grid {
  static List<MapPolyline> w3wGrid = [];
  static bool w3wGridDisplayed = false;

  static List<List<double>> getBoundingBox(double lat, double lon) {
    const EARTH_RADIUS = 6371.0088; // in km
    double diagonal = 2.0; // diagonal length in km

    double halfDiagonal = diagonal / sqrt(2);
    double latOffset = halfDiagonal / EARTH_RADIUS * 180 / pi;
    double lonOffset = latOffset / cos(lat * pi / 180);

    // calculate diagonal coordinates
    double diagonalLat1 = lat + latOffset;
    double diagonalLon1 = lon + lonOffset;
    double diagonalLat2 = lat - latOffset;
    double diagonalLon2 = lon - lonOffset;

    return [
      [diagonalLat1, diagonalLon1],
      [diagonalLat2, diagonalLon2]
    ];
  }

  static Future<void> obtainGrid() async {
    // Center to user's current location
    MapScreenRes.goToUserLoc();
    // Calculate bouding box
    List<List<double>> box = getBoundingBox(
        Services.userLocation.latitude, Services.userLocation.longitude);
    String boxString = box[0][0].toString() +
        ',' +
        box[0][1].toString() +
        ',' +
        box[1][0].toString() +
        ',' +
        box[1][1].toString();
    var url = Uri.https('api.what3words.com', 'v3/grid-section', {
      'key': Services.getSecret('what3words.api.key')!,
      'bounding-box': boxString,
      'format': 'json'
    });
    // Making the request
    var response = await http.get(url);
    Fluttertoast.showToast(msg: 'Request Made!');
    print('Request Made!');

    try {
      Map<String, dynamic> parsed =
          jsonDecode(response.body).cast<String, dynamic>();
      List<GeoCoordinates> coordinates = [];
      double widthInPixels = 2;

      if (parsed.containsKey('lines')) {
        print('Request OK');
        List lines = parsed['lines'];
        for (Map element in lines) {
          coordinates.add(
              GeoCoordinates(element['start']['lat'], element['start']['lng']));
          coordinates.add(
              GeoCoordinates(element['end']['lat'], element['end']['lng']));
          w3wGrid.add(MapPolyline(GeoPolyline(coordinates), widthInPixels,
              Color.fromARGB(255, 49, 214, 203)));
          coordinates.clear();
        }
      } else
        print(parsed['error']);
    } catch (e) {
      print(e);
    }

    // Set listener for zoom panning
    Services.mapController.gestures.pinchRotateListener =
        PinchRotateListener(((p0, p1, p2, p3, p4) {
      print("zommed out");
      Fluttertoast.showToast(msg: "zoomed out");
      if (Services.mapController.camera.state.zoomLevel >= 20.768 &&
          !w3wGridDisplayed) {
        // _displayGrid();
        print("zommed in");
        Fluttertoast.showToast(msg: "zoomed in");
      } else if (Services.mapController.camera.state.zoomLevel < 20.768) {
        // _removeGrid();
      }
    }));

    // Fluttertoast.showToast(msg: response.body);
  }

  static void _displayGrid() {
    w3wGridDisplayed = true;
    for (MapPolyline polyline in w3wGrid) {
      Services.mapController.mapScene.addMapPolyline(polyline);
    }
  }

  static void _removeGrid() {
    w3wGridDisplayed = false;
    for (MapPolyline polyline in w3wGrid) {
      Services.mapController.mapScene.removeMapPolyline(polyline);
    }
  }
}
