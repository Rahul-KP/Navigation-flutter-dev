import 'package:AmbiNav/search_res.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static bool isVisible = false;
  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  static void toggleVisibility() {
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
                    hintText: 'Enter destination',
                  ),
                  onSubmitted: (
                    (value) {
                      Services.search.obj.initRoutingEngine();
                      Services.search.search(value);
                      SearchWidget.toggleVisibility();
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
