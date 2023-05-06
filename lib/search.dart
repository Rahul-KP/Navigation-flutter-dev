import 'package:AmbiNav/main.dart';
import 'package:AmbiNav/map_functions.dart';
import 'package:AmbiNav/marker_details_ui.dart';
import 'package:AmbiNav/routing.dart';
import 'package:AmbiNav/search_result_metadata.dart';
import 'package:AmbiNav/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_sdk/core.errors.dart'; //for handling search instantiation Exception
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/core.dart' as core;
import 'package:here_sdk/search.dart';
// import 'main.dart' as mm;

class Search {
  MapImage? _poiMapImage;
  List<MapMarker> _mapMarkerList = [];
  static var setStateMarkerDetailsCard;
  static String place = "";
  static String vicinity = "";
  Routing obj = Routing();

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/' + fileName);
    return Uint8List.view(fileData.buffer);
  }

  Future<MapMarker> _addPoiMapMarker(core.GeoCoordinates geoCoordinates) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      _poiMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _poiMapImage!);
    MapServices.mapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);

    return mapMarker;
  }

  Future<void> addPoiMapMarker(
      core.GeoCoordinates geoCoordinates, core.Metadata metadata) async {
    MapMarker mapMarker = await _addPoiMapMarker(geoCoordinates);
    mapMarker.metadata = metadata;
  }

  void search(String queryString, Services sobj) async {
    // Code to implement search functionality
    //clear map markers before every search
    MapServices().clearMapMarkers(_mapMarkerList);
    //instantiate search engine
    late SearchEngine _searchEngine;
    try {
      _searchEngine = SearchEngine();
    } on InstantiationException {
      throw Exception("Initialization of SearchEngine failed.");
    }

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = core.LanguageCode.enUs;
    searchOptions.maxItems = 30;

    //build the search query
    TextQueryArea queryArea = TextQueryArea.withCenter(await MapServices().getCurrentLoc());
    TextQuery query = TextQuery.withArea(queryString, queryArea);

    // _searchEngine.searchByText(query, searchOptions, (p0, p1) { });

    _searchEngine.searchByText(query, searchOptions,
        (SearchError? searchError, List<Place>? list) async {
      if (searchError != null) {
        // showDialog("Search", "Error: " + searchError.toString());
        Fluttertoast.showToast(msg: searchError.toString());
        return;
      }

      // If error is null, list is guaranteed to be not empty.
      int listLength = list!.length;
      // _showDialog("Search for $queryString", "Results: $listLength. Tap marker to see details.");
      Fluttertoast.showToast(
          msg: "$queryString" +
              "\nResults: $listLength. Tap marker to see details");

      // Add new marker for each search result on map.
      for (Place searchResult in list) {
        core.Metadata metadata = core.Metadata();
        metadata.setCustomValue(
            "key_search_result", SearchResultMetadata(searchResult));
        // Note: getGeoCoordinates() may return null only for Suggestions.
        // SharedData.mapController.
        addPoiMapMarker(searchResult.geoCoordinates!, metadata);
      }
    });
  }

  void _pickMapMarker(core.Point2D touchPoint, Services sobj) {
    double radiusInPixel = 2;
    obj.initRoutingEngine(sobj);
    MapServices.mapController.pickMapItems(touchPoint, radiusInPixel,
        (pickMapItemsResult) async {
      if (pickMapItemsResult == null) {
        // Pick operation failed.
        return;
      }
      List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
      if (mapMarkerList.length == 0) {
        // setStateMarkerDetailsCard(()=>DisplayMarkerInfo.toggleVisisbility());
        setStateMarkerDetailsCard(() => DisplayMarkerInfo.isVisible = false);
        print("No map markers found.");
        return;
      }

      // setStateMarkerDetailsCard(()=>DisplayMarkerInfo.isVisible=true);
      MapMarker topmostMapMarker = mapMarkerList.first;
      core.Metadata? metadata = topmostMapMarker.metadata;
      if (metadata != null) {
        core.CustomMetadataValue? customMetadataValue =
            metadata.getCustomValue("key_search_result");
        if (customMetadataValue != null) {
          SearchResultMetadata searchResultMetadata =
              customMetadataValue as SearchResultMetadata;
          place = searchResultMetadata.searchResult.title;
          vicinity = searchResultMetadata.searchResult.address.addressText;

          await obj.addRoute(searchResultMetadata.searchResult.geoCoordinates!);

          // setStateMarkerDetailsCard(() {
          //   DisplayMarkerInfo.isVisible = true;
            
          // });
          return;
        }
      }

      // double lat = topmostMapMarker.coordinates.latitude;
      // double lon = topmostMapMarker.coordinates.longitude;
    });
  }


  void markerInfo(context) {
    Scaffold.of(context).showBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      (BuildContext context) {
        return Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
            color: Color.fromARGB(255, 159, 211, 214),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  // alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 80,
                      child: ListTile(
                        title: Text(Search.place),
                        subtitle: Text(Search.vicinity),
                      )),
                ),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void setTapGestureHandler() {
    TapListener listener = TapListener((core.Point2D touchPoint) {
      _pickMapMarker(touchPoint, sobj);
    });
    MapServices().setTapGestureHandler(listener);
  }
}