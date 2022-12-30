import 'package:AmbiNav/search_result_metadata.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/core.errors.dart'; //for handling search instantiation Exception
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:location/location.dart';
import 'shared_data.dart';
typedef ShowDialogFunction = void Function(String title, String message);

class MapScreenRes {
  MapImage? _poiMapImage;
  List<MapMarker> _mapMarkerList = [];
  ShowDialogFunction _showDialog;

  MapScreenRes(ShowDialogFunction showDialogCallback)
  :_showDialog = showDialogCallback;

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/' + fileName);
    return Uint8List.view(fileData.buffer);
  }

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

  Future<void> addPoiMapMarker(core.GeoCoordinates geoCoordinates, core.Metadata metadata) async {
    MapMarker mapMarker = await _addPoiMapMarker(geoCoordinates);
    mapMarker.metadata = metadata;
  }

  void search() async {
    // Code to implement search functionality
    //clear map markers before every search
    _clearMap();
    //instantiate search engine
    late SearchEngine _searchEngine;
    try {
      _searchEngine =  SearchEngine();
    }
    on InstantiationException {
      throw Exception("Initialization of SearchEngine failed.");
    }

    _setTapGestureHandler();

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = core.LanguageCode.enUs;
    searchOptions.maxItems = 30;

    //Device's current location
    LocationData loc = await SharedData.locationData.first;
    
    //build the search query
    TextQueryArea queryArea = TextQueryArea.withCenter(core.GeoCoordinates(loc.latitude!,loc.longitude!));
    String queryString = "pizza";//needs to be read from search overlay
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
      _showDialog("Search for $queryString", "Results: $listLength. Tap marker to see details.");

      // Add new marker for each search result on map.
      for (Place searchResult in list!) {
        core.Metadata metadata = core.Metadata();
        metadata.setCustomValue("key_search_result", SearchResultMetadata(searchResult));
        // Note: getGeoCoordinates() may return null only for Suggestions.
        // SharedData.mapController. 
        addPoiMapMarker(searchResult.geoCoordinates!, metadata);
      }
    });
  }
  
  void _pickMapMarker(core.Point2D touchPoint) {
    double radiusInPixel = 2;
    SharedData.mapController.pickMapItems(touchPoint, radiusInPixel, (pickMapItemsResult) {
      if (pickMapItemsResult == null) {
        // Pick operation failed.
        return;
      }
      List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
      if (mapMarkerList.length == 0) {
        print("No map markers found.");
        return;
      }

      MapMarker topmostMapMarker = mapMarkerList.first;
      core.Metadata? metadata = topmostMapMarker.metadata;
      if (metadata != null) {
        core.CustomMetadataValue? customMetadataValue = metadata.getCustomValue("key_search_result");
        if (customMetadataValue != null) {
          SearchResultMetadata searchResultMetadata = customMetadataValue as SearchResultMetadata;
          String title = searchResultMetadata.searchResult.title;
          String vicinity = searchResultMetadata.searchResult.address.addressText;
          _showDialog("Picked Search Result", title + ". Vicinity: " + vicinity);
          return;
        }
      }

      double lat = topmostMapMarker.coordinates.latitude;
      double lon = topmostMapMarker.coordinates.longitude;
      _showDialog("Picked Map Marker", "Geographic coordinates: $lat, $lon.");
    });
  }

  void _setTapGestureHandler() {
    SharedData.mapController.gestures.tapListener = TapListener((core.Point2D touchPoint) {
      _pickMapMarker(touchPoint);
    });
  }

  void _clearMap() {
    _mapMarkerList.forEach((mapMarker) {
      SharedData.mapController.mapScene.removeMapMarker(mapMarker);
    });
    _mapMarkerList.clear();
  }
}
