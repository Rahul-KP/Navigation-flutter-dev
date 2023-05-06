import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  late String username;
  late String usertype;

  Future<String?> getCred(String key) {
    var box = Hive.openBox('creds');
    box.then((value) {
      return value.get(key);
    });
    return Future<Null>.value(null);
  }

  void setCred(String key, String value) {
    var box = Hive.openBox('creds');
    box.then((value_) {
      value_.put(key, value);
    });
  }

  void logout() async {
    Hive.deleteBoxFromDisk('creds');
    SharedPreferences login = await SharedPreferences.getInstance();
    login.setBool('login', true);
  }

  void bookAmbulance() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Bookings");
    var box = await Hive.openBox('booking');
    //call to hashing function
    Fluttertoast.showToast(msg: "Booking Successful!");
    ref.update({
      box.get('hash'): {
        "patient_name": box.get('name'),
        "age": box.get('age'),
        "preferred_hospital": box.get('preferred_hosp'),
        "gender": box.get('gender'),
        "user_location": {
          "lat": box.get('lat'),
          "lon": box.get('lon'),
        }
      }
    });
  }
}
