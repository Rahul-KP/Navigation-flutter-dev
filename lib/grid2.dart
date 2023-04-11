import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:what3words/what3words.dart';

class Grid {
  var _api;
  List<MapPolyline> lines = [];

  void init() async {
    Services _sobj = Services();
    _api = What3WordsV3(_sobj.getSecret('what3words.api.key')!);
    await Hive.initFlutter(); 
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
  }
}
