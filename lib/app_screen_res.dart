import 'package:AmbiNav/ambulance_form.dart';
import 'package:AmbiNav/app_screen_ui.dart';
import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/login.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/search.dart';
import 'package:AmbiNav/search_overlay_ui.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppScreenRes {
  late var setStateOverlay;
  late var bookingSetStateOverlay;
  late SearchWidget searchWidget;
  late Search seobj;
  Grid grid = Grid();
  late var context;

  void setContext(var context) {
    this.context = context;
  }

  Widget? chooseOverlayWidget(Services sobj) {
    if (sobj.usertype == 'user') {
      return SearchWidget(
        seobj: seobj,
      );
    } else if (sobj.usertype == 'driver') {
      return NavigationNotif(
        sobj: sobj,
        appScreenRes: this,
      );
    }
    return null;
  }

  List<Widget> getDrawerOptions(BuildContext context, Services sobj) {
    List<Widget> drawerButtonList = [];
    drawerButtonList.add(GestureDetector(
      child: ListTile(
        title: const Text("Logout"),
        leading: Icon(Icons.logout_rounded),
      ),
      onTap: () async {
        sobj.logout();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => loginpg(
                      sobj: sobj,
                    ))));
      },
    ));
    if (sobj.usertype == 'user') {
      drawerButtonList.add(GestureDetector(
        child: ListTile(
          title: const Text('Book an ambulance'),
          leading: Icon(Icons.edit_note_rounded),
        ),
        onTap: () {
          AppScreen.scaffoldKey.currentState!.closeDrawer();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AmbulanceForm(
                        sobj: sobj,
                      )));
        },
      ));
    }
    return drawerButtonList;
  }

  List<Widget> getActionButtonList(Services sobj) {
    seobj = Search(context, sobj);
    searchWidget = SearchWidget(seobj: seobj);
    List<Widget> actionButtonList = [];
    actionButtonList.add(Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: ((() async {
              Fluttertoast.showToast(
                  msg: MapServices.mapController.camera.state.zoomLevel
                      .toString());
              if (grid.isDisplayed) {
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
              onPressed: (() => this
                  .setStateOverlay(() => searchWidget.toggleVisibility())))));
    } else if (sobj.usertype == 'driver') {
      actionButtonList.add(Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: IconButton(
              icon: Icon(Icons.navigation),
              onPressed: (() =>
                  Fluttertoast.showToast(msg: "Have a good day")))));
    }

    return actionButtonList;
  }
}
