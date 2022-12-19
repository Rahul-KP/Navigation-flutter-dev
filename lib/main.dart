import 'package:flutter/material.dart';
import 'package:navigation/AmbDriverDetails.dart';
import 'package:navigation/userDetails.dart';
// import 'login_screen.dart';
import 'get_location.dart';
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//demonstarting git to sumedh

Widget appScreen = loginpg();

void alreadyLoggedin() {
  SharedPreferences.getInstance().then((value) {
    bool newuser = (value.getBool('login') ?? true);

    // print(newuser);

    if (newuser == false) {
      appScreen = Pos();

      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (context) => Pos()));
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  alreadyLoggedin();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: appScreen,
  ));
}
