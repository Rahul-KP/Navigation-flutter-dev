

import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/countdown_timer.dart';
import 'package:AmbiNav/end_destination_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';

class NavigationNotif extends StatefulWidget {
  final AppScreenRes appScreenRes;
  static late GeoCoordinates patientLoc;
  static late String hashvalue;
  final Services sobj;

  NavigationNotif({super.key, required this.appScreenRes, required this.sobj});
  static bool isVisible = false;

  @override
  State<NavigationNotif> createState() => _NavigationNotifState();

  static void toggleVisibility(GeoCoordinates? patientLoc, String hash) {
    if (patientLoc != null) {
      NavigationNotif.patientLoc = patientLoc;
      hashvalue = hash;
    }
    isVisible = !isVisible;
  }
}

class _NavigationNotifState extends State<NavigationNotif> {
  Routing rt = Routing();

  @override
  void initState() {
    super.initState();
    rt.initRoutingEngine(widget.sobj);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: GestureDetector(
          onTap: () async {
            // GeoCoordinates patientLoc = GeoCoordinates(
            //     double.parse(sobj.formDetails
            //         .child('user_location/lat')
            //         .value
            //         .toString()),
            //     double.parse(sobj.formDetails
            //         .child('user_location/lon')
            //         .value
            //         .toString()));
            widget.sobj.currentLocRef = FirebaseDatabase.instance.ref(
                'Bookings/' + NavigationNotif.hashvalue + '/ambulance_loc');
            widget.sobj.isBooking = true;
            rt.addRoute(NavigationNotif.patientLoc);
            // //after the formhas been accepted by the driver , stop listening to other forms
            Services.listen.cancel();
            DatabaseReference ref1 = FirebaseDatabase.instance
                .ref('Bookings/' + NavigationNotif.hashvalue);
            print((ref1.get()).runtimeType.toString());
            var flag = await ref1.get();
            print(flag.value);
            Fluttertoast.showToast(msg: "Printing flag");
            Fluttertoast.showToast(msg: flag.value.toString());
            ref1.onChildAdded.listen((event) {
              if (event.snapshot.key.toString() == "Reached") {
                Services.endDestinationSetSateOverlay(() {
                  EndDes.isVisible = true;
                  EndDes.rt = this.rt;
                });
              }
            });
          },
          child: CountDownTimer(
            appScreenRes: widget.appScreenRes,
          )),
      visible: NavigationNotif.isVisible,
    );
  }
}
