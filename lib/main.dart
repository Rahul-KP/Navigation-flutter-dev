import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_screen_ui.dart';

void loadCreds() async {
  await dotenv.load(fileName: "credentials.env");
}
void main() {
  loadCreds();
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}