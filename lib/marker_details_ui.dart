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
      child: Center(
      child: ElevatedButton(
        child: const Text('showBottomSheet'),
        onPressed: () {
          Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              return Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
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
              );
            },
          );
        },
      ),
    ),
      visible: DisplayMarkerInfo.isVisible,
    );
    // return Center(
    //   child: ElevatedButton(
    //     child: const Text('showBottomSheet'),
    //     onPressed: () {
    //       Scaffold.of(context).showBottomSheet<void>(
    //         (BuildContext context) {
    //           return Container(
    //             height: 180,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(20.0),
    //                   topLeft: Radius.circular(20.0)),
    //               color: Color.fromARGB(255, 159, 211, 214),
    //             ),
    //             child: Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: <Widget>[
    //                   Align(
    //                     // alignment: Alignment.bottomCenter,
    //                     child: Container(
    //                         height: 80,
    //                         child: ListTile(
    //                           title: Text(Search.place),
    //                           subtitle: Text(Search.vicinity),
    //                         )),
    //                   ),
    //                   ElevatedButton(
    //                     child: const Text('Close BottomSheet'),
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}
