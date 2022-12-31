import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:location/location.dart';

class SharedData {
  static late Stream<LocationData> locationData; // user's location
  static late HereMapController mapController;
  static late RoutingEngine routingEngine;
  static late BuildContext mapContext;
}
