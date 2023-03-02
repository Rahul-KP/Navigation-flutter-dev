import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ambulance_form.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class MapScreenRes {
  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    // LocationData ld = await Services.locationData.first;
    Services.mapController.camera.lookAtPoint(Services.userLocation);
  }

  static List<List<double>> getBoundingBox(double latitude, double longitude) {
    // Earth radius in meters
    const EARTH_RADIUS = 6378137.0;

    // Convert latitude and longitude to radians
    double latRad = latitude * pi / 180;
    double lonRad = longitude * pi / 180;

    // Calculate the distance in meters between the center of the square and its corner
    double distance = sqrt(2) * 2000;

    // Calculate the latitude and longitude of the diagonal points
    double lat1 = asin(sin(latRad) * cos(distance / EARTH_RADIUS) +
        cos(latRad) * sin(distance / EARTH_RADIUS) * cos(pi / 4));
    double lon1 = lonRad +
        atan2(sin(pi / 4) * sin(distance / EARTH_RADIUS) * cos(latRad),
            cos(distance / EARTH_RADIUS) - sin(latRad) * sin(lat1));

    double lat2 = asin(sin(latRad) * cos(distance / EARTH_RADIUS) +
        cos(latRad) * sin(distance / EARTH_RADIUS) * cos(5 * pi / 4));
    double lon2 = lonRad +
        atan2(sin(5 * pi / 4) * sin(distance / EARTH_RADIUS) * cos(latRad),
            cos(distance / EARTH_RADIUS) - sin(latRad) * sin(lat2));

    // Convert latitude and longitude back to degrees
    lat1 = lat1 * 180 / pi;
    lon1 = lon1 * 180 / pi;
    lat2 = lat2 * 180 / pi;
    lon2 = lon2 * 180 / pi;

    // Return the coordinates of the diagonal points
    return [
      [lat1, lon1],
      [lat2, lon2]
    ];
  }

  static Future<void> displayGrid() async {
    goToUserLoc();
    var url = Uri.https('api.what3words.com', 'v3/grid-section?key=&bounding-box=&format=json');
    List<List<double>> box = getBoundingBox(
        Services.userLocation.latitude, Services.userLocation.longitude);
    
  }

  static List<Widget> getActionButtonList() {
    List<Widget> actionButtonList = [];
    actionButtonList.add(Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
            icon: Icon(Icons.grid_4x4_rounded),
            onPressed: ((() async {
              await displayGrid();
            })))));
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
