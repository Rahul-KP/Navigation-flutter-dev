import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_screen_ui.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart'; //for handling InstantiationException while initializing sdk
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'starter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  _initializeHERESDK();
  alreadyLoggedin();
}
