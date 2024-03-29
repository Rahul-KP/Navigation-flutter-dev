import 'package:AmbiNav/search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayMarkerInfo extends StatefulWidget {
  static bool isVisible = false;
  static bool addInfo = false;

  DisplayMarkerInfo({super.key});

  static void toggleVisisbility() {
    isVisible = !isVisible;
  }

  static addressInfo(addInfo) {
    if (addInfo) {
      addInfo = false;
    } else {
      addInfo = true;
    }
  }

  @override
  State<DisplayMarkerInfo> createState() => _DisplayMarkerInfoState();
}

class _DisplayMarkerInfoState extends State<DisplayMarkerInfo> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
            color: Color.fromARGB(255, 159, 211, 214),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  // alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 80,
                      child: ListTile(
                        title: Text(Search.place),
                        subtitle: Text(Search.vicinity),
                      )),
                ),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
    //   child: Center(

    //     child:  Scaffold.of(context).showBottomSheet<void>(
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(30.0),
    //       topRight: Radius.circular(30.0),
    //     ),
    //   ),
    //   (BuildContext context) {
    //     return 
    //   },
    // );,
        
      visible: DisplayMarkerInfo.isVisible,
    );
  }
}
