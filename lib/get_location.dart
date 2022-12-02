import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'search.dart';
import 'shared_data.dart';
import 'map.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:location/location.dart';
import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

class _PosState extends State<Pos> {
  void getPermissions() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _loc;

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
    SharedData.locationData = location.onLocationChanged;
    // function();
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.moveCamera(
        CameraUpdate.newLatLngZoom(LatLng(ld.latitude!, ld.longitude!), 18));
    // SharedData.userLoc = LatLng(ld.latitude!, ld.longitude!);
  }

  // void locationUpdater() async {
  //   await for (LocationData ld in SharedData.locationData) {
  //     SharedData.userLoc
  //     // SharedData.mapController.moveCamera(
  //     //     CameraUpdate.newLatLngZoom(LatLng(ld.latitude!, ld.longitude!), 14));
  //     // Fluttertoast.showToast(
  //     //     msg: "Location Data updated!", backgroundColor: Colors.amber);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getPermissions();
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
                  onTap: () async {
                    // SearchWidget.isVisible = !SearchWidget.isVisible;
                    // setStateOverlay(() {
                    //   SearchWidget.toggleVisisbility();
                    // });
                    LocationData ld = await SharedData.locationData.first;
                    AutocompleteResult x = await openPlaceAutocomplete(
                        PlaceOptions(
                            enableTextSearch: true,
                            hint: "Choose your destination",
                            location: LatLng(ld.latitude!, ld.longitude!)));

                    SharedData.mapController.moveCameraWithELoc(
                        CameraELocUpdate.newELocZoom(x.eLocation!.eLoc!, 14));
                    SharedData.mapController
                        .addSymbol(SymbolOptions(eLoc: x.eLocation!.eLoc));
                    Fluttertoast.showToast(msg: x.eLocation!.eLoc!.toString());
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
          ]),
      body: Stack(
        children: <Widget>[
          MapWidget(),
          StatefulBuilder(builder: ((context, setState) {
            setStateOverlay = setState;
            return SearchWidget();
          })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() async {
            LocationData ld = await SharedData.locationData.first;
            SharedData.mapController.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(ld.latitude!, ld.longitude!), 18));
            SharedData.mapController.easeCamera(CameraUpdate.newLatLngZoom(
                LatLng(ld.latitude!, ld.longitude!), 18));
            
            Fluttertoast.showToast(msg: ld.toString());
            // SharedData.mapController.moveCamera(CameraUpdate.newLatLngZoom(
            //     LatLng(ld.latitude!, ld.longitude!),
            //     18)); // animate and ease camera functions here
          }),
          child: const Icon(
            Icons.add_location_alt_outlined,
            color: Colors.white,
          )),
    );
  }
}
