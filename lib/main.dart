import 'package:AmbiNav/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'app_screen_ui.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart'; //for handling InstantiationException while initializing sdk
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Clear the cache occupied by a previous instance.
  await SDKNativeEngine.sharedInstance?.dispose();

  //loading the .env file
  await dotenv.load(fileName: "credentials.env");
  // Set your credentials for the HERE SDK.
  String accessKeyId = dotenv.env["here.access.key.id"]!;
  String accessKeySecret = dotenv.env["here.access.key.secret"]!;
  SDKOptions sdkOptions =
      SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void alreadyLoggedin() {
  SharedPreferences.getInstance().then((value) {
    bool newuser = (value.getBool('login') ?? true);

    if (newuser == false) {
      Services.usertype = value.getString('usertype')!;
      Services.username = value.getString('username')!;
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppScreen(),
      ));
    } else {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginpg(),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeHERESDK(); // initialise the HERE SDK
  await Services.getPermissions(); // wait for permissions
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  alreadyLoggedin(); // check if user is already logged in
  Services.setLoc(); // start streaming the location
}
