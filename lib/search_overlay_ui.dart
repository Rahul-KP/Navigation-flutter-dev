import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/search.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  Search seobj;
  SearchWidget({super.key, required this.seobj});

  static bool isVisible = false;
  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  void toggleVisibility() {
    isVisible = !isVisible;
    if (isVisible == true) {
      seobj.setTapGestureHandler();
    } else {
      MapServices().clearMapMarkers(seobj.mapMarkerList);
    }
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
                    hintText: 'Enter destination',
                  ),
                  onSubmitted: ((value) {
                    widget.seobj.search(value);
                    // SearchWidget.toggleVisibility();
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
