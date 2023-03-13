import 'dart:convert';
import 'dart:math';
import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class Grid {
  static bool w3wGridDisplayed = false;
  static var w3wBox = null;

  static void init() async {
    await Hive.initFlutter(); // Initialize hive
    w3wBox = await Hive.openBox('w3wgrid'); // Opening a box
  }

  static List<List<double>> getBoundingBox(double lat, double lon) {
    const EARTH_RADIUS = 6371.0088; // in km
    double diagonal = 0.5; // diagonal length in km

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
        
      if (parsed.containsKey('lines')) {
        print('Request OK');
        w3wBox.put('grid', parsed['lines']);
        _setTapGestureHandler();
      } else
        print(parsed['error']);
    } catch (e) {
      print(e);
    }

    // Set listener for zoom panning
    Services.mapController.gestures.pinchRotateListener =
        PinchRotateListener(((p0, p1, p2, p3, p4) {
      if (Services.mapController.camera.state.zoomLevel >= 20.768 &&
          !w3wGridDisplayed) {
        _displayGrid();
      } else if (Services.mapController.camera.state.zoomLevel < 20.768 &&
          w3wGridDisplayed) {
        _removeGrid();
      }
    }));

    // Fluttertoast.showToast(msg: response.body);
  }

  static void _displayGrid() async {
    List<GeoCoordinates> coordinates = [];
    double widthInPixels = 2;
    List lines = w3wBox.get('grid');
    print("i ran");
    for (Map element in lines) {
      coordinates.add(
          GeoCoordinates(element['start']['lat'].toDouble(), element['start']['lng'].toDouble()));
      coordinates
          .add(GeoCoordinates(element['end']['lat'].toDouble(), element['end']['lng'].toDouble()));
      Services.mapController.mapScene.addMapPolyline(MapPolyline(
          GeoPolyline(coordinates),
          widthInPixels,
          Color.fromARGB(255, 49, 214, 203)));
      coordinates.clear();
    }
    w3wGridDisplayed = true;
  }

  static void _removeGrid() async {
    List<GeoCoordinates> coordinates = [];
    double widthInPixels = 2;
    List lines = w3wBox.get('grid');
    print("i did ran");
    for (Map element in lines) {
      coordinates.add(
          GeoCoordinates(element['start']['lat'].toDouble(), element['start']['lng'].toDouble()));
      coordinates
          .add(GeoCoordinates(element['end']['lat'].toDouble(), element['end']['lng'].toDouble()));
      Services.mapController.mapScene.removeMapPolyline(MapPolyline(
          GeoPolyline(coordinates),
          widthInPixels,
          Color.fromARGB(255, 49, 214, 203)));
      coordinates.clear();
    }
    w3wGridDisplayed = false;
  }

  static void _setTapGestureHandler() {
    Services.mapController.gestures.tapListener =
        TapListener((Point2D touchPoint) async {
      GeoCoordinates geoCoordinates = Services.mapController.viewToGeoCoordinates(touchPoint)!;
      print('Tap at: '+ geoCoordinates.latitude.toString()+'\n' +geoCoordinates.longitude.toString());
      Fluttertoast.showToast(msg: 'Tap at: '+ geoCoordinates.latitude.toString()+'\n' +geoCoordinates.longitude.toString());
      
      //code to get 3 word address onTap of a particular location
      var url = Uri.https('api.what3words.com','v3/convert-to-3wa?', {
        'key': Services.getSecret('what3words.api.key'),
        'coordinates':geoCoordinates.latitude.toString()+'%2C-'+geoCoordinates.longitude.toString(),
      });
      var response = await http.get(url);
      try {
      Map<String, dynamic> parsed =
          jsonDecode(response.body).cast<String, dynamic>();
          if(parsed.containsKey('words')){
            print('3word request successful');
            Fluttertoast.showToast(msg: parsed['words']);
            print(parsed['words']);
          }
          else {
            print('something went worng');
          }
      }
      catch(e){
        print(e);
      }
    });
  }
}
