import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'shared_data.dart';
import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static bool isVisible = false;
  static void toggleVisisbility() {
    isVisible = !isVisible;
  }

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
          margin: EdgeInsets.all(30),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Choose your destination',
                  ),
                  onTap: (() async {
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
                  }),
                ),
              ],
            ),
            shadowColor: Colors.lightGreen,
            elevation: 20,
          )),
      visible: SearchWidget.isVisible,
    );
  }
}
