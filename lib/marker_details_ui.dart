import 'package:AmbiNav/search_res.dart';
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
          title: Text(SearchRes.place),
          subtitle: Text(SearchRes.vicinity),
        )),
      ),
      visible: DisplayMarkerInfo.isVisible,
    );
  }
}
