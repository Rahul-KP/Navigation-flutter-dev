// import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/booking_map_ui.dart';
import 'package:AmbiNav/grid2.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/marker_details_ui.dart';
import 'package:AmbiNav/search_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'app_screen_res.dart';
import 'map.dart';

class AppScreen extends StatefulWidget {
  Grid? grid;
  AppScreen({super.key, required Services sobj, this.grid});
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  MapScreenRes mapScreenRes = MapScreenRes();

  @override
  void initState() {
    super.initState();
    sobj.mapContext = this.context;
    if (sobj.usertype == 'driver') {
      mapScreenRes.listenToBookings(sobj);
    }
    if (sobj.usertype == 'user') {
      mapScreenRes.listenToRequest(); // For path broadcast
    }
    if (widget.grid != null) {
      AppScreen.scaffoldKey.currentState!.closeDrawer();
      widget.grid!.getGrid();
    } else {
      sobj.postLogin();
    }
  }

  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  var setStateOverlay;
  var setStateMarkerDetailsCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppScreen.scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(children: mapScreenRes.getDrawerOptions(context, sobj)),
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
          actions: mapScreenRes.getActionButtonList(sobj)),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(sobj: sobj),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            Services.setStateOverlay = setState;
            return mapScreenRes.chooseOverlayWidget(sobj)!;
          })),

          StatefulBuilder(builder: ((context, setState) {
            Services.setStateOverlay = setState;
            return BookingWidget(
                grid: widget.grid,
                isVisible: (widget.grid != null) ? true : false);
          })),

          StatefulBuilder(builder: ((context, setState) {
            SearchRes.setStateMarkerDetailsCard = setState;
            return DisplayMarkerInfo();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          //this button moves the camera to user's current location - recenter button
          onPressed: () async {
            mapScreenRes.goToUserLoc(sobj);
          },
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
