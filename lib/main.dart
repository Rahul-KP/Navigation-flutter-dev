import 'package:flutter/material.dart';
import 'app_screen_ui.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart'; //for handling InstantiationException while initializing sdk

import 'package:flutter_dotenv/flutter_dotenv.dart';

void _initializeHERESDK() async {

  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  //loading the .env file
  await dotenv.load(fileName: "credentials.env");
  // Set your credentials for the HERE SDK.
  String accessKeyId = dotenv.env["here.access.key.id"]!;
  String accessKeySecret = dotenv.env["here.access.key.secret"]!;
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void main() {
  _initializeHERESDK();
  runApp(MaterialApp(
    home: AppScreen(),
  ));
}