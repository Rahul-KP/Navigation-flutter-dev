import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:here_sdk/core.dart';
import 'package:http/http.dart';

class W3Words {
  String? apiKey;
  String baseUrl = 'api.what3words.com';
  String urlPath = '/v3/convert-to-3wa?&language=en&format=json';

  Future<void> init() async {
    await dotenv.load(fileName: "credentials.env");
    apiKey = dotenv.env["what3words.api.key"]!;
  }

  Future<String> convertToWords(GeoCoordinates point) async {
    Uri url = Uri.https(
        baseUrl,
        urlPath +
            '&coordinates=' +
            point.latitude.toString() +
            ',' +
            point.longitude.toString());
    String words = '';
    if (apiKey != null) {
      try {
        Response response = await get(url, headers: {'X-Api-Key': apiKey!});
        words = jsonDecode(response.body)['words'];
      } catch (e) {
        print(e);
      }
    }
    return words;
  }
}
