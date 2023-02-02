import 'dart:convert';

import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ambulance_form.dart';

class MapScreenRes {
  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    // LocationData ld = await Services.locationData.first;
    Services.mapController.camera.lookAtPoint(Services.userLocation);
  }

  static List<Widget> getActionButtonList() {
    List<Widget> actionButtonList = [];
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

  static List<Widget> _getDrawerOptionsW3w() {
    List<Widget> w3wButtonList = [];
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Clear all routes'),
        leading: Icon(Icons.clear_all_rounded),
      ),
      onTap: () {
        Grid.obj.clearMap();
      },
    ));
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Plot path to square'), // Button 2 - plot path from clg to square u select
        leading: Icon(Icons.task),
      ),
      onTap: () {
        if(Grid.target != null) {
          Grid.obj.addRoute(Grid.source, Grid.target!);
        }
      },
    ));
    return w3wButtonList;
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
    drawerButtonList.addAll(_getDrawerOptionsW3w());
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

  static _parse(String dataString) {
    // Remove the square brackets at the beginning and end of the string
    dataString = dataString.substring(1, dataString.length - 1);

    // Split the string into separate coordinate objects
    List<String> coordinateStrings = dataString.split("},{");

    // Loop through each coordinate object string and extract the latitude and longitude
    List<GeoCoordinates> coordinates = [];
    for (String coordinateString in coordinateStrings) {
      // Remove the curly braces at the beginning and end of the coordinate string
      coordinateString =
          coordinateString.replaceAll("{", "").replaceAll("}", "");

      // Split the coordinate string into separate latitude and longitude values
      List<String> values = coordinateString.split(", ");

      // Extract the latitude and longitude values and add them to the list of coordinates
      double lon = double.parse(values[0].split(": ")[1]);
      double lat = double.parse(values[1].split(": ")[1]);
      coordinates.add(GeoCoordinates(lat, lon));
    }
    GeoPolyline geoPolyline;
    try {
      geoPolyline = GeoPolyline(coordinates);
      return geoPolyline;
    } on InstantiationException {
      // Thrown when less than two vertices.
      print("Oh shit!");
      return null;
    }
  }

  static void listenToRequest() async {
    Routing routing = Routing();
    DatabaseReference ref = FirebaseDatabase.instance.ref("Drivers");
    Routing rt = Routing();
    rt.initRoutingEngine();
    ref.onChildChanged.listen((event) {
      DataSnapshot d = event.snapshot;
      for (var i in d.children) {
        print(i.hasChild('route'));
        // Fluttertoast.showToast(msg: i.value.toString());
        Fluttertoast.showToast(msg: i.value.toString());
        print(i.value.runtimeType.toString());
        rt.showRouteOnMap(_parse(i.value.toString()));
      }
    });
  }
}
