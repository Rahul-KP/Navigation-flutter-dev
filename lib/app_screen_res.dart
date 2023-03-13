import 'dart:convert';
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ambulance_form.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class MapScreenRes {
  static List<MapPolyline> w3wGrid = [];
  static bool w3wGridDisplayed = false;

  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    // LocationData ld = await Services.locationData.first;
    Services.mapController.camera.lookAtPoint(Services.userLocation);
  }

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
    goToUserLoc();
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

  static List<Widget> getActionButtonList() {
    List<Widget> actionButtonList = [];
    actionButtonList.add(Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
            icon: Icon(Icons.grid_4x4_rounded),
            onPressed: ((() async => await obtainGrid())))));
    actionButtonList.add(Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
            icon: Icon(Icons.zoom_out_map_rounded),
            onPressed: ((() async => Fluttertoast.showToast(
                msg: Services.mapController.camera.state.zoomLevel
                    .toString()))))));
    if (Services.usertype == 'user') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (() => Services.setStateOverlay(
                  () => SearchWidget.toggleVisibility())))));
    } else if (Services.usertype == 'driver') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.navigation),
              onPressed: (() => Services.setStateOverlay(
                  () => NavigationNotif.toggleVisibility())))));
    }

    return actionButtonList;
  }

  static List<Widget> getDrawerOptions(BuildContext context) {
    List<Widget> drawerButtonList = [];
    drawerButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text("Logout"),
        leading: Icon(Icons.logout_rounded),
      ),
      onTap: () async {
        SharedPreferences logindata = await SharedPreferences.getInstance();
        logindata.setBool('login', true);
        logindata.setString('username', "");
        logindata.setString('usertype', "");
        Services.usertype = "";
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => loginpg())));
      },
    ));
    if (Services.usertype == 'user') {
      drawerButtonList.add(GestureDetector(
        child: ListTile(
          title: const Text('Book an ambulance'),
          leading: Icon(Icons.edit_note_rounded),
        ),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AmbulanceForm())),
      ));
    }
    return drawerButtonList;
  }

  static void listenToBookings() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    Services.listen = ref.onChildAdded.listen((event) {
      Services.formDetails = event.snapshot;
      Services.setStateOverlay(() => NavigationNotif.toggleVisibility());
    });
  }

  static void search() async {
    // Code to implement search functionality
  }

  static Widget? chooseOverlayWidget() {
    if (Services.usertype == 'user') {
      return SearchWidget();
    } else if (Services.usertype == 'driver') {
      return NavigationNotif();
    }
    return null;
  }

  static void listenToRequest() async {
    Routing routing = Routing();
    DatabaseReference ref = FirebaseDatabase.instance.ref("Drivers");
    ref.onChildChanged.listen((event) {
      DataSnapshot d = event.snapshot;
      for (var i in d.children) {
        i.child('/route');
        print(i.hasChild('route'));
        Fluttertoast.showToast(msg: i.children.length.toString());
        //make a Geoordinates list
        List<GeoCoordinates> patientPath = [];
        for (var j in i.children) {
          try {
            GeoCoordinates geoCoordinates = GeoCoordinates(
                double.parse(j.child('lat').toString()),
                double.parse(j.child('lon').toString()));
            patientPath.add(geoCoordinates);
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
            break;
          }
          routing.showRouteOnMap(GeoPolyline(patientPath));
        }
      }
    });
  }
}
