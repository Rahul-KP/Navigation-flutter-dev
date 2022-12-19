import 'package:flutter/material.dart';
import 'package:navigation/AmbDriverDetails.dart';
import 'package:navigation/userDetails.dart';
// import 'login_screen.dart';
import 'get_location.dart';
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//demonstarting git to sumedh

void alreadyLoggedin() {
  SharedPreferences.getInstance().then((value) {
    bool newuser = (value.getBool('login') ?? true);

    // print(newuser);

    if (newuser == false) {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Pos(),
      ));

      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (context) => Pos()));
    }
    else{
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginpg(),
      ));
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  alreadyLoggedin();
}
