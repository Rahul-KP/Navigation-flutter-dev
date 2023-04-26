
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'grid2.dart' as gd;

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static bool isVisible = false;
  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  static void toggleVisibility() {
    isVisible = !isVisible;
    if(isVisible == false) {
      // Grid.setTapGestureHandler();
       gd.Grid grid = gd.Grid();

      grid.getGrid();

    } else {
      Services.search.setTapGestureHandler();
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
                      Services.search.obj.initRoutingEngine(sobj);
                      Services.search.search(value,sobj);
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
