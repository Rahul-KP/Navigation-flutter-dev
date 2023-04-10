import 'package:AmbiNav/app_screen_res.dart';
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

  void toggleVisibility() {
    isVisible = !isVisible;
  }
}

class _NavigationNotifState extends State<NavigationNotif> {
  Routing rt = Routing();
  MapScreenRes mobj = MapScreenRes();
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
                double.parse(mobj.formDetails
                    .child('user_location/lat')
                    .value
                    .toString()),
                double.parse(mobj.formDetails
                    .child('user_location/lon')
                    .value
                    .toString()));
            rt.addRoute(Services.userLocation, patientLoc);
            //after the formhas been accepted by the driver , stop listening to other forms
            mobj.listen.cancel();
          },
          child: CountDownTimer()),
      visible: NavigationNotif.isVisible,
    );
  }
}
