import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'search.dart';
import 'shared_data.dart';
import 'map.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:location/location.dart';
import 'package:mapmyindia_direction_plugin/mapmyindia_direction_plugin.dart';
import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';

class Pos extends StatefulWidget {
  const Pos({super.key});

  @override
  State<Pos> createState() => _PosState();
}

class _PosState extends State<Pos> {
  List points = [
    [77.586099, 12.928568],
    [77.586147, 12.928513],
    [77.586344, 12.928015],
    [77.586387, 12.927709],
    [77.586399, 12.92741],
    [77.586388, 12.927221],
    [77.586284, 12.926786],
    [77.586046, 12.926296],
    [77.585996, 12.926102],
    [77.585951, 12.924732],
    [77.585936, 12.923283],
    [77.584831, 12.92329],
    [77.582749, 12.923366],
    [77.581161, 12.923387],
    [77.5803, 12.923419],
    [77.577959, 12.923441],
    [77.576252, 12.923484],
    [77.574824, 12.923479],
    [77.572548, 12.92354],
    [77.571138, 12.92386],
    [77.570343, 12.924062],
    [77.570496, 12.924831],
    [77.570498, 12.924954],
    [77.57045, 12.925348],
    [77.570399, 12.925531],
    [77.570322, 12.925714],
    [77.570027, 12.926112],
    [77.569832, 12.926283],
    [77.56953, 12.926441],
    [77.569274, 12.926552],
    [77.568632, 12.926768],
    [77.568272, 12.926935],
    [77.567969, 12.927255],
    [77.567892, 12.927393],
    [77.567848, 12.927589],
    [77.567827, 12.927853],
    [77.56785, 12.928107],
    [77.567918, 12.9285],
    [77.567472, 12.928586],
    [77.565224, 12.928954],
    [77.563972, 12.929191],
    [77.562884, 12.929416],
    [77.562785, 12.929387],
    [77.562715, 12.929283],
    [77.562425, 12.928514],
    [77.562097, 12.927827],
    [77.561249, 12.926459],
    [77.561055, 12.926046],
    [77.560954, 12.925702],
    [77.560897, 12.925374],
    [77.560785, 12.925401],
    [77.559989, 12.925363],
    [77.55927, 12.925366],
    [77.559108, 12.924404],
    [77.558749, 12.924413],
    [77.558141, 12.924491],
    [77.558181, 12.924632]
  ];

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
                    // LocationData ld = await SharedData.locationData.first;
                    // AutocompleteResult x = await openPlaceAutocomplete(
                    //     PlaceOptions(
                    //         enableTextSearch: true,
                    //         hint: "Choose your destination",
                    //         location: LatLng(ld.latitude!, ld.longitude!)));
                    // ELocation destination = x.eLocation!;
                    // // Fluttertoast.showToast(msg: "User: " + ld.latitude!.toString() + ";" + ld.longitude!.toString());
                    // SharedData.mapController.moveCameraWithELoc(
                    //     CameraELocUpdate.newELocZoom(destination.eLoc!, 14));
                    // SharedData.mapController
                    //     .addSymbol(SymbolOptions(eLoc: destination.eLoc));
                    // Fluttertoast.showToast(msg: x.eLocation!.placeAddress!);
                    // Fluttertoast.showToast(
                    //     msg: y.directionResponse!.routes!.first.geometry!);
                    List<LatLng> x = [];
                    for (int i = 0; i < points.length; i++) {
                      x.add(LatLng(points[i][1], points[i][0]));
                    }

                    // Fluttertoast.showToast(msg: x.first.toString());

                    SharedData.mapController.addLine(LineOptions(geometry: x, lineColor: "#30beff", lineWidth: 6));
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
