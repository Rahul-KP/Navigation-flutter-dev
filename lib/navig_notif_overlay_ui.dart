import 'package:AmbiNav/countdown_timer.dart';
import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
// import 'main.dart' as mm;

class NavigationNotif extends StatefulWidget {
  const NavigationNotif({super.key, required Services sobj});
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
    rt.initRoutingEngine(sobj);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: GestureDetector(
          onTap: () async {
            GeoCoordinates patientLoc = GeoCoordinates(
                double.parse(sobj.formDetails
                    .child('user_location/lat')
                    .value
                    .toString()),
                double.parse(sobj.formDetails
                    .child('user_location/lon')
                    .value
                    .toString()));
            rt.addRoute(patientLoc);
            //after the formhas been accepted by the driver , stop listening to other forms
            sobj.listen.cancel();
          },
          child: CountDownTimer()),
      visible: NavigationNotif.isVisible,
    );
  }
}
