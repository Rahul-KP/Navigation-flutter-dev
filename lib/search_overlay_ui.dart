import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_res.dart';
import 'package:firebase_database/firebase_database.dart';
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

  late SearchRes search;

  @override
  void initState() {
    super.initState();
    Routing obj = Routing();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    obj.initRoutingEngine();
    search = SearchRes(ref, obj);
  }

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
                      search.search(value);
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
