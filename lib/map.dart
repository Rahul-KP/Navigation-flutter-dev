import 'package:flutter/material.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late MapmyIndiaMapController mapController;

  @override
  Widget build(BuildContext context) {
    return MapmyIndiaMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(25.321684, 82.987289),
        zoom: 14.0,
      ),
      onMapCreated: (map) => {
        mapController = map,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    MapmyIndiaAccountManager.setMapSDKKey('a05c6075d66b09820619e8efe2aef2cf');
    MapmyIndiaAccountManager.setRestAPIKey('a05c6075d66b09820619e8efe2aef2cf');
    MapmyIndiaAccountManager.setAtlasClientId(
        '33OkryzDZsK4ReW9DxeyOhm-q-cd0y-oLSaj1NBQIspvJt-LOG-vGeeY2xY6qqCjNH0_XNbSokAxOxh9Al3o2A==');
    MapmyIndiaAccountManager.setAtlasClientSecret(
        'lrFxI-iSEg_Y2C2oDtIhEkfQsLbAc2gjn1YuVQ48_yeM1o8W-XAwbPK9sSZsXR7xSrp1-W0BV2TQ03jew_wFOp7NyCll9Zji');
  }
}
