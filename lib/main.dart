import 'package:AmbiNav/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'app_screen_ui.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart'; //for handling InstantiationException while initializing sdk
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> _initializeHERESDK(Services sobj) async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Clear the cache occupied by a previous instance.
  await SDKNativeEngine.sharedInstance?.dispose();

  // Set your credentials for the HERE SDK.
  String accessKeyId = sobj.getSecret("here.access.key.id")!;
  String accessKeySecret = sobj.getSecret("here.access.key.secret")!;
  SDKOptions sdkOptions =
      SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void alreadyLoggedin(sobj) {
  SharedPreferences.getInstance().then((value) {
    bool newuser = (value.getBool('login') ?? true);
    if (newuser == false) {
      // Services.usertype = value.getString('usertype')!;
      sobj.usertype = value.getString('usertype')!;
      sobj.username = value.getString('username')!;
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

void checkLoginStatus() {
  FirebaseAuth.instance.idTokenChanges().listen((User? user) {
    if (user == null) {
      Fluttertoast.showToast(msg: "User is currently signed out!");
    } else {
      Fluttertoast.showToast(msg: "User is signed in!");
    }
  });
}

Services sobj = Services();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await sobj.loadCreds();
  await _initializeHERESDK(sobj); // initialise the HERE SDK
  await sobj.getPermissions(); // wait for permissions

  checkLoginStatus();
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
    Fluttertoast.showToast(msg: userCredential.user!.uid);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
  checkLoginStatus();
  alreadyLoggedin(sobj); // check if user is already logged in
  sobj.setLoc(); // start streaming the location
}
