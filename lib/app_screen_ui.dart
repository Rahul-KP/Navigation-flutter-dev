import 'package:flutter/material.dart';
import 'search.dart';
import 'app_screen_res.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  void initState() {
    super.initState();
    MapScreenRes.getPermissions();
  }

  var setStateOverlay;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(),
      appBar: AppBar(
          title: Text("Navigation"),
          leading: IconButton(
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
                child: GestureDetector(
                  onTap: MapScreenRes.search,
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
          ]),
      body: Stack(
        children: <Widget>[
          // MapWidget
          StatefulBuilder(builder: ((context, setState) {
            setStateOverlay = setState;
            return SearchWidget();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (MapScreenRes.gotoUserLoc),
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
