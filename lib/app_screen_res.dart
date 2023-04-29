// import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/grid2.dart' as gd;
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'app_screen_ui.dart';
import 'services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ambulance_form.dart';
// import 'main.dart' as mm;

class MapScreenRes {
  gd.Grid grid = gd.Grid();
  void goToUserLoc(Services sobj) async {
    // Code to move the camera to user's current location
    // LocationData ld = await Services.locationData.first;
    Services.mapController.camera.lookAtPoint(sobj.userLocation);
  }

  List<Widget> getActionButtonList(Services sobj) {
    List<Widget> actionButtonList = [];
    actionButtonList.add(Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: ((() async {
              Fluttertoast.showToast(
                  msg:
                      Services.mapController.camera.state.zoomLevel.toString());
              if(grid.isDisplayed) {
                grid.removeGrid();
              } else {
                grid.getGrid();
              }
            })))));
    if (sobj.usertype == 'user') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (() => Services.setStateOverlay(
                  () => SearchWidget.toggleVisibility())))));
    } else if (sobj.usertype == 'driver') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.navigation),
              onPressed: (() => Services.setStateOverlay(
                  () => NavigationNotif.toggleVisibility())))));
    }

    return actionButtonList;
  }

  List<Widget> _getDrawerOptionsW3w() {
    List<Widget> w3wButtonList = [];
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text('Clear all routes'),
        leading: Icon(Icons.clear_all_rounded),
      ),
      onTap: () {
        // gd.Grid.obj.clearMap();
        AppScreen.scaffoldKey.currentState!.closeDrawer();
        grid.removeGrid();
        Services.search.clearMap();
      },
    ));
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text(
            'Plot path to square'), // Button 2 - plot path from clg to square u select
        leading: Icon(Icons.task),
      ),
      onTap: () {
        if (gd.Grid.target != null) {
          gd.Grid.obj.addRoute(gd.Grid.source);
        }
      },
    ));
    w3wButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text(
            'Plot path between 2 squares'), // Button 2 - plot path from clg to square u select
        leading: Icon(Icons.square_sharp),
      ),
      onTap: () {
        //allow to squares to be selected
        gd.Grid.choose2Squares = !gd.Grid.choose2Squares;
        Fluttertoast.showToast(msg: 'tapped');
      },
    ));
    return w3wButtonList;
  }

  List<Widget> getDrawerOptions(BuildContext context, Services sobj) {
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
        sobj.usertype = "";
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => loginpg(
                      sobj: sobj,
                    ))));
      },
    ));
    drawerButtonList.addAll(_getDrawerOptionsW3w());
    if (sobj.usertype == 'user') {
      drawerButtonList.add(GestureDetector(
        child: ListTile(
          title: const Text('Book an ambulance'),
          leading: Icon(Icons.edit_note_rounded),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AmbulanceForm(
                      sobj: sobj,
                    ))),
      ));
    }
    return drawerButtonList;
  }

  void listenToBookings(Services sobj) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    sobj.listen = ref.onChildAdded.listen((event) {
      sobj.formDetails = event.snapshot;
      Services.setStateOverlay(() => NavigationNotif.toggleVisibility());
    });
  }

  Widget? chooseOverlayWidget(Services sobj) {
    if (sobj.usertype == 'user') {
      return SearchWidget();
    } else if (sobj.usertype == 'driver') {
      return NavigationNotif(
        sobj: sobj,
      );
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
