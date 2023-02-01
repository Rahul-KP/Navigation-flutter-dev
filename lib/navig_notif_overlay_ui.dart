import 'package:AmbiNav/countdown_timer.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';

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
            GeoCoordinates patientLoc = GeoCoordinates(
                double.parse(Services.formDetails
                    .child('user_location/lat')
                    .value
                    .toString()),
                double.parse(Services.formDetails
                    .child('user_location/lon')
                    .value
                    .toString()));
            rt.addRoute(Services.userLocation, patientLoc);
          },
          child: CountDownTimer()),
      visible: NavigationNotif.isVisible,
    );
  }
}
