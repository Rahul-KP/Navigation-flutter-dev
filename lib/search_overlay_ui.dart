import 'package:AmbiNav/grid.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static bool isVisible = false;
  static final Grid gobj = Grid();
  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  void toggleVisibility() {
    isVisible = !isVisible;
    if(isVisible == false) {
      gobj.setTapGestureHandler();
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
                      Services.search.obj.initRoutingEngine();
                      Services.search.search(value);
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
