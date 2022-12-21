import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'app_screen_ui.dart';
import 'here_test.dart';

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = dotenv.env['here.access.key.id']!;
  String accessKeySecret = dotenv.env['here.access.key.secret']!;
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void loadCreds() async {
  await dotenv.load(fileName: "credentials.env");
}
void main() {
  loadCreds();
  _initializeHERESDK();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}