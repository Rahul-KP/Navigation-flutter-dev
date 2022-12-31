import 'package:flutter/material.dart';

class DisplayMarkerInfo extends StatefulWidget {
  
  static late String place;
  static late String vicinity; 
  DisplayMarkerInfo(String p,String v,{super.key}) {
    place = p;
    vicinity = v;
  }
  @override
  State<DisplayMarkerInfo> createState() => _DisplayMarkerInfoState();
}

class _DisplayMarkerInfoState extends State<DisplayMarkerInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(DisplayMarkerInfo.place),
            subtitle: Text(DisplayMarkerInfo.vicinity),
          )
        ]
      ),
    );
  }
}