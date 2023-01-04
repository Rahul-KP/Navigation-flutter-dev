import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:location/location.dart';

class SharedData {
  static late Stream<LocationData> locationData; // user's location
  static late HereMapController mapController;
  static late RoutingEngine routingEngine;
  //used to reference setState() for search widget (setState is copied to this variable in StatefulBuilder)
  static late var setStateOverlay;
  static late String usertype;
  static late BuildContext mapContext;
}
