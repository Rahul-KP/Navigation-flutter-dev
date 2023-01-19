import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ambulance_form.dart';
import 'shared_data.dart';

class MapScreenRes {
  static void getPermissions() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // Stream of data containing user's current location
    SharedData.locationData = location.onLocationChanged;
  }

  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.camera
        .lookAtPoint(core.GeoCoordinates(ld.latitude!, ld.longitude!));
  }

  static List<Widget> getActionButtonList() {
    List<Widget> actionButtonList = [];
    if (SharedData.usertype == 'user') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (() => SharedData.setStateOverlay(
                  () => SearchWidget.toggleVisibility())))));
    } else if (SharedData.usertype == 'driver') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.navigation),
              onPressed: (() => SharedData.setStateOverlay(
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
        SharedData.usertype = "";
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => loginpg())));
      },
    ));
    if (SharedData.usertype == 'user') {
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

  static void listenToBookings() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    ref.onChildAdded.listen((event){
      for (var element in event.snapshot.children) {
        print(element.key.toString()+":"+element.value.toString());
      }
    });
  }

  static void search() async {
    // Code to implement search functionality
  }

  static Widget? chooseOverlayWidget() {
    if (SharedData.usertype == 'user') {
      return SearchWidget();
    } else if (SharedData.usertype == 'driver') {
      return NavigationNotif();
    }
    return null;
  }
}
