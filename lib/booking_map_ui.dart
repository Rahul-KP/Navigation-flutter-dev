import 'package:AmbiNav/booking_map.dart';
import 'package:AmbiNav/grid2.dart';
import 'package:AmbiNav/marker_details_ui.dart';
import 'package:AmbiNav/search_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_screen_res.dart';
import 'map.dart';

class AppScreen extends StatefulWidget {
  final Services sobj;
  final BookingDetails booking;
  final Grid grid;
  AppScreen(
      {super.key,
      required this.sobj,
      required this.grid,
      required this.booking});
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  var setStateOverlay;
  var setStateMarkerDetailsCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppScreen.scaffoldKey,
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
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    icon: Icon(Icons.grid_on),
                    onPressed: ((() async {
                      Fluttertoast.showToast(
                          msg: Services.mapController.camera.state.zoomLevel
                              .toString());
                      if (widget.grid.isDisplayed) {
                        widget.grid.removeGrid();
                        Fluttertoast.showToast(msg: "Sheesh");
                        widget.sobj.bookAmbulance(widget.booking);
                      }
                    }))))
          ]),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(sobj: widget.sobj),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            Services.setStateOverlay = setState;
            return MapScreenRes().chooseOverlayWidget(widget.sobj)!;
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
            MapScreenRes().goToUserLoc(widget.sobj);
          },
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
