import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:math' as math;

class FireListener {
  late Services sobj;

  FireListener(Services sobj) {
    this.sobj = sobj;
  }

  void listenToBookings(AppScreenRes appScreenRes) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Bookings');
    ref.onChildAdded.listen((event) async {
      double lat = double.parse(
          event.snapshot.child('user_location/lat').value.toString());
      double long = double.parse(
          event.snapshot.child('user_location/lon').value.toString());
      appScreenRes.setStateOverlay(() {
        NavigationNotif.toggleVisibility(
            GeoCoordinates(lat, long), event.snapshot.key.toString());
      });
    });
  }

  void listenToAcceptance() async {
    var box = await Hive.openBox('booking');
    String hash = box.get('hash');
    listenToAmbLoc();
    // Fluttertoast.showToast(msg: "Hash is " + hash);
    DatabaseReference ref = FirebaseDatabase.instance.ref('Bookings/' + hash);
    ref.onChildAdded.listen((event) async {
      Object? data = event.snapshot.value;
      // Fluttertoast.showToast(msg: data.toString());
      if (data.runtimeType.toString() != 'String') {
        List d = data as List;
        _convertToPolyline(d);
      }
    });
  }

  _convertToPolyline(List l) {
    List<GeoCoordinates> newlist = [];
    l.forEach((element) {
      newlist.add(GeoCoordinates(element['lat'], element['lon']));
    });
    Routing rt = Routing();
    rt.initRoutingEngine(sobj);
    rt.showRouteOnMap(GeoPolyline(newlist));
    // Fluttertoast.showToast(msg: "LIGHT");
  }

  void listenToAmbLoc() async {
    var box = await Hive.openBox('booking');
    String hash = box.get('hash');
    double lat = 0, long = 0;
    bool flag = false;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('Bookings/' + hash + '/ambulance_loc');
    ref.onChildChanged.listen((event) {
      // Fluttertoast.showToast(msg: "This is " + event.snapshot.value.toString());
      if (event.snapshot.key == 'lat') {
        lat = double.parse(event.snapshot.value.toString());
      } else if (event.snapshot.key == 'lon') {
        long = double.parse(event.snapshot.value.toString());
        flag = true;
      }
      if (flag) {
        // Fluttertoast.showToast(
        //     msg: "You are at " + lat.toString() + ", " + long.toString());
        sobj.updateAmbLoc(GeoCoordinates(lat, long));
        flag = false;
        //check if the ambulance has arrived
        MapServices().getCurrentLoc().then((useloc) {
          double d = distance(lat, long, useloc.latitude, useloc.longitude);
          if (d < 300) {
            //code the part to end trip
            Fluttertoast.showToast(msg: "Ambulance in vicinity");
          }
        });
      }
    });
  }

  double distance(double lat1, double lon1, double lat2, double lon2) {
    double r = 6371; // radius of the Earth in km
    double phi1 = math.pi * lat1 / 180;
    double phi2 = math.pi * lat2 / 180;
    double delta_phi = math.pi * (lat2 - lat1) / 180;
    double delta_lambda = math.pi * (lon2 - lon1) / 180;
    double a = math.sin(delta_phi / 2) * math.sin(delta_phi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(delta_lambda / 2) *
            math.sin(delta_lambda / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = r * c * 1000; // distance in km
    return d;
  }
}
