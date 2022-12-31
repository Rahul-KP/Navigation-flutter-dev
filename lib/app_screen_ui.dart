import 'package:AmbiNav/search_res.dart';
import 'package:AmbiNav/shared_data.dart';
import 'package:flutter/material.dart';
import 'search_overlay_ui.dart';
import 'app_screen_res.dart';
import 'map.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
    SharedData.mapContext = this.context;
    MapScreenRes.getPermissions();
  }

  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  var setStateOverlay;
  
  SearchRes search = new SearchRes();
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
          title: Text("Navigation"),
          leading: IconButton(
            //hamburger icon
            icon: Icon(Icons.menu),
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              } else {
                scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.search),
                // onPressed: (() =>
                //     setStateOverlay(() => SearchWidget.toggleVisisbility())),
                onPressed: (() => search.search()),
              ),
            ),
          ]),
      body: Stack(
        children: <Widget>[
          // MapWidget
          MapWidget(),
          //here the stateful builder is used to render search widget of search.dart (a card element to enter destination)
          //it renders without redrawing the entire screen
          //if the below lines are not included , map will be redrawn every time the search button is toggled
          StatefulBuilder(builder: ((context, setState) {
            setStateOverlay = setState;
            return SearchWidget();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          //this button moves the camera to user's current location - recenter button
          onPressed: (MapScreenRes.goToUserLoc),
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
