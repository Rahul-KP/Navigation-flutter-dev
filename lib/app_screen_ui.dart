// import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/marker_details_ui.dart';
import 'package:AmbiNav/search_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'app_screen_res.dart';
import 'map.dart';
// import 'main.dart' as mm;

class AppScreen extends StatefulWidget {
  AppScreen({super.key,required Services sobj});
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
    sobj.postLogin();
    if (sobj.usertype == 'driver') {
      mapScreenRes.listenToBookings(sobj);
    }
    if (sobj.usertype == 'user') {
      mapScreenRes.listenToRequest(); // For path broadcast
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
          child: Column(children: MapScreenRes.getDrawerOptions(context,sobj)),
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
          actions: MapScreenRes.getActionButtonList(sobj)),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(sobj:sobj),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            Services.setStateOverlay = setState;
            return MapScreenRes.chooseOverlayWidget(sobj)!;
          })),

          StatefulBuilder(builder: ((context, setState) {
            SearchRes.setStateMarkerDetailsCard = setState;
            return DisplayMarkerInfo();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          //this button moves the camera to user's current location - recenter button
          onPressed: () async{
            mapScreenRes.goToUserLoc(sobj);
          },
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
