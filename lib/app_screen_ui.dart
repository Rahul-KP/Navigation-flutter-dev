// import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/booking_map_ui.dart';
import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/map.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/marker_details_ui.dart';
import 'package:AmbiNav/search.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatefulWidget {
  Grid? grid = null;

  AppScreen({super.key, required Services sobj, this.grid});
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {

  AppScreenRes appScreenRes = AppScreenRes();

  @override
  void initState() {
    super.initState();
    if (widget.grid != null) {
      widget.grid!.getGrid();
    }
  }

  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  // var setStateOverlay;
  // var bookingSetStateOverlay;
  var setStateMarkerDetailsCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppScreen.scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(children: appScreenRes.getDrawerOptions(context, sobj)),
        ),
      ),
      appBar: AppBar(
          title: Text("Navigation"),
          leading: IconButton(
            //hamburger icon
            icon: Icon(Icons.menu),
            onPressed: () {
              if (AppScreen.scaffoldKey.currentState!.isDrawerOpen) {
                AppScreen.scaffoldKey.currentState!.closeDrawer();
              } else {
                AppScreen.scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
          actions: appScreenRes.getActionButtonList(sobj)),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(sobj: sobj),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            appScreenRes.setStateOverlay = setState;
            return appScreenRes.chooseOverlayWidget(sobj)!;
          })),

          StatefulBuilder(builder: ((context, setState) {
            appScreenRes.bookingSetStateOverlay = setState;
            return BookingWidget(
                grid: widget.grid,
                isVisible: (widget.grid != null) ? true : false);
          })),

          StatefulBuilder(builder: ((context, setState) {
            Search.setStateMarkerDetailsCard = setState;
            return DisplayMarkerInfo();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          //this button moves the camera to user's current location - recenter button
          onPressed: () async {
            MapServices().goToUserLoc();
          },
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
