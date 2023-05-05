import 'package:AmbiNav/search.dart';
import 'package:flutter/material.dart';

class DisplayMarkerInfo extends StatefulWidget {
  static bool isVisible = false;

  DisplayMarkerInfo({super.key});
  static void toggleVisisbility() {
    isVisible = !isVisible;
  }

  @override
  State<DisplayMarkerInfo> createState() => _DisplayMarkerInfoState();
}

class _DisplayMarkerInfoState extends State<DisplayMarkerInfo> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 100,
            child: ListTile(
          title: Text(Search.place),
          subtitle: Text(Search.vicinity),
        )),
      ),
      visible: DisplayMarkerInfo.isVisible,
    );
  }
}