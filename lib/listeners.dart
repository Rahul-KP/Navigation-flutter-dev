import 'package:AmbiNav/app_screen_res.dart';
import 'package:AmbiNav/navig_notif_overlay_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart';
import 'package:hive_flutter/adapters.dart';

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
    DatabaseReference ref = FirebaseDatabase.instance.ref('results');
    ref.onChildChanged.listen((event) async {
      Object? data = event.snapshot.value;
      Fluttertoast.showToast(msg: data.toString());
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
    Fluttertoast.showToast(msg: hash);
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('Bookings/' + hash + '/ambulance_loc');
    ref.onChildChanged.listen((event) {
      double lat = double.parse(event.snapshot.child('lat').value.toString());
      double long = double.parse(event.snapshot.child('lon').value.toString());
      Services().updateAmbLoc(GeoCoordinates(lat, long));
    });
  }
}
