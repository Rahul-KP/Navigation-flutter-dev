
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'grid.dart' as gd;

class SearchWidget extends StatefulWidget {
  Services sobj;
  SearchWidget({super.key, required this.sobj});

  static bool isVisible = false;
  final Search search = Search();
  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  void toggleVisibility() {
    isVisible = !isVisible;
    if(isVisible == false) {
      // Grid.setTapGestureHandler();
       gd.Grid grid = gd.Grid();

      grid.getGrid();

    } else {
      search.setTapGestureHandler();
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
                  onSubmitted: (
                    (value) {
                      Search sobj = Search();
                      sobj.search(value, widget.sobj);
                      // SearchWidget.toggleVisibility();
                    } 
                  ),
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