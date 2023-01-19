import 'package:AmbiNav/countdown_timer.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/shared_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:location/location.dart';

class NavigationNotif extends StatefulWidget {
  const NavigationNotif({super.key});
  static bool isVisible = false;

  @override
  State<NavigationNotif> createState() => _NavigationNotifState();

  static void toggleVisibility() {
    isVisible = !isVisible;
  }
}

class _NavigationNotifState extends State<NavigationNotif> {
  Routing rt = Routing();

  @override
  void initState() {
    super.initState();
    rt.initRoutingEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: GestureDetector(
          onTap: () async {
            LocationData ld = await SharedData.locationData.first;
            GeoCoordinates userLoc = GeoCoordinates(
                double.parse(SharedData.formDetails
                    .child('user_location/lat')
                    .value
                    .toString()),
                double.parse(SharedData.formDetails
                    .child('user_location/lon')
                    .value
                    .toString()));
            rt.addRoute(GeoCoordinates(ld.latitude!, ld.longitude!), userLoc);
          },
          child: CountDownTimer()),
      visible: NavigationNotif.isVisible,
    );
  }
}
