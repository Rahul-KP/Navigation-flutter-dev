import 'package:AmbiNav/grid.dart';
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

class MapScreenRes {
  void goToUserLoc() async {
    // Code to move the camera to user's current location
    // LocationData ld = await Services.locationData.first;
    Services.mapController.camera.lookAtPoint(Services.userLocation);
  }

  List<Widget> getActionButtonList() {
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
    Grid gobj = Grid();
    List<Widget> w3wButtonList = [];
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Clear all routes'),
        leading: Icon(Icons.clear_all_rounded),
      ),
      onTap: () {
        gobj.obj.clearMap();
        Services.search.clearMap();
      },
    ));
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Plot path to square'), // Button 2 - plot path from clg to square u select
        leading: Icon(Icons.task),
      ),
      onTap: () {
        if(gobj.target != null) {
          gobj.obj.addRoute(gobj.target!, gobj.source);
        }
      },
    ));
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Plot path between 2 squares'), // Button 2 - plot path from clg to square u select
        leading: Icon(Icons.square_sharp),
      ),
      onTap: () {
        //allow to squares to be selected
        gobj.choose2Squares = !gobj.choose2Squares;
        Fluttertoast.showToast(msg: 'tapped');
      },
    ));
    return w3wButtonList;
  }

  List<Widget> getDrawerOptions(BuildContext context) {
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

  void listenToBookings() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    Services.listen = ref.onChildAdded.listen((event) {
      Services.formDetails = event.snapshot;
      Services.setStateOverlay(() => NavigationNotif.toggleVisibility());
    });
  }

  static void search() async {
    // Code to implement search functionality
  }

  Widget? chooseOverlayWidget() {
    if (Services.usertype == 'user') {
      return SearchWidget();
    } else if (Services.usertype == 'driver') {
      return NavigationNotif();
    }
    return null;
  }

  void listenToRequest() async {
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
