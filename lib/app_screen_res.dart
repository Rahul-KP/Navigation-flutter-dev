import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:flutter/material.dart';
import 'services.dart';

class MapScreenRes {
  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    // LocationData ld = await SharedData.locationData.first;
    Services.mapController.camera.lookAtPoint(Services.userLocation);
  }

  static List<Widget> getActionButtonList() {
    List<Widget> actionButtonList = [];
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
}
