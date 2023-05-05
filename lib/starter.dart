import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:here_sdk/core.dart' as here_core;
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:location/location.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Starter {
  Future<void> loadCreds() async {
    //loading the .env file
    await Hive.initFlutter();
    await dotenv.load(fileName: "credentials.env");
  }

  String? getSecret(String key) {
    return dotenv.env[key];
    //here.access.key.id
  }

  Future<void> initializeHERESDK() async {
    // Needs to be called before accessing SDKOptions to load necessary libraries.
    here_core.SdkContext.init(here_core.IsolateOrigin.main);

    // Clear the cache occupied by a previous instance.
    await SDKNativeEngine.sharedInstance?.dispose();

    // Set your credentials for the HERE SDK.
    String accessKeyId = this.getSecret("here.access.key.id")!;
    String accessKeySecret = this.getSecret("here.access.key.secret")!;
    SDKOptions sdkOptions =
        SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

    try {
      await SDKNativeEngine.makeSharedInstance(sdkOptions);
    } on InstantiationException {
      throw Exception("Failed to initialize the HERE SDK.");
    }
  }

  Future<void> firebaseLogin() async {
    try {
      // final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      // Fluttertoast.showToast(msg: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  Future<void> getPermissions() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // LocationData temp = await location.getLocation();
    // userLocation = core.GeoCoordinates(temp.latitude!, temp.longitude!);
  }

  void loadHiveBox(String username, String usertype) async {
    var box = await Hive.openBox('creds');
    box.put('username', username);
    box.put('usertype', usertype);
  }
}
