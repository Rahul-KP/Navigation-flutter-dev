import 'package:flutter/material.dart';

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
                  hintText: 'Enter a place',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a destination',
                ),
              ),
            ],
          ),
          shadowColor: Colors.lightGreen,
          elevation: 20,
        )
      ),
      visible: SearchWidget.isVisible,
    );
  }
}
