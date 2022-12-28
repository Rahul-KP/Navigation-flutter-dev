import 'package:AmbiNav/search_result_metadata.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/core.errors.dart'; //for handling search instantiation Exception
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:location/location.dart';
import 'shared_data.dart';

class MapScreenRes {
  static void getPermissions() async {
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
    // Stream of data containing user's current location
    SharedData.locationData = location.onLocationChanged;
  }

  static void goToUserLoc() async {
    // Code to move the camera to user's current location
    LocationData ld = await SharedData.locationData.first;
    SharedData.mapController.camera
        .lookAtPoint(core.GeoCoordinates(ld.latitude!, ld.longitude!));
    
  }

  static void search() async {
    // Code to implement search functionality
    
    //instantiate search engine
    SearchEngine _searchEngine;
    try {
      _searchEngine =  SearchEngine();
    }
    on InstantiationException {
      throw Exception("Initialization of SearchEngine failed.");
    }

    //Device's current location
    LocationData loc = await SharedData.locationData.first;

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = core.LanguageCode.enUs;
    searchOptions.maxItems = 30;

    //build the search query
    TextQueryArea queryArea = TextQueryArea.withCenter(core.GeoCoordinates(loc.latitude!,loc.longitude!));
    String queryString = "Decathalon";//needs to be read from search overlay
    TextQuery query = TextQuery.withArea(queryString, queryArea);
    
    // _searchEngine.searchByText(query, searchOptions, (p0, p1) { });

    _searchEngine.searchByText(query, searchOptions, (SearchError? searchError, List<Place>? list) async {
      if (searchError != null) {
        // showDialog("Search", "Error: " + searchError.toString());
        Fluttertoast.showToast(msg: searchError.toString());
        return;
      }

      // If error is null, list is guaranteed to be not empty.
      int listLength = list!.length;
      // _showDialog("Search for $queryString", "Results: $listLength. Tap marker to see details.");

      // Add new marker for each search result on map.
      for (Place searchResult in list) {
        core.Metadata metadata = core.Metadata();
        metadata.setCustomValue("key_search_result", SearchResultMetadata(searchResult));
        // Note: getGeoCoordinates() may return null only for Suggestions.
        // SharedData.mapController. 
        // addPoiMapMarker(searchResult.geoCoordinates!, metadata);
      }
    });

    MapImage? _poiMapImage;
    Future<MapMarker> _addPoiMapMarker(core.GeoCoordinates geoCoordinates) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      _poiMapImage = MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _poiMapImage!);
    SharedData.mapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);

    return mapMarker;
  }

  }
}
