import 'package:AmbiNav/app_screen_ui.dart';
import 'package:AmbiNav/firebase_options.dart';
import 'package:AmbiNav/login.dart';
import 'package:AmbiNav/services.dart';
import 'package:AmbiNav/starter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Starter starter = Starter();
Services sobj = Services();

void login() {
  SharedPreferences.getInstance().then((value) {
    bool newuser = (value.getBool('login') ?? true);
    if (newuser == false) {
      // Services.usertype = value.getString('usertype')!;
      sobj.usertype = value.getString('usertype')!;
      sobj.username = value.getString('username')!;
      starter.loadHiveBox(value.getString('username')!, value.getString('usertype')!);
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppScreen(
          sobj: sobj,
        ),
      ));
    } else {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginpg(
          sobj: sobj,
        ),
      ));
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await starter.loadCreds();
  await starter.initializeHERESDK();
  await starter.getPermissions();
  await starter.firebaseLogin();

  login();
}