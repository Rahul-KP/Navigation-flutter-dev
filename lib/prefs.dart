import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;
  static void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void saveData(String key, String data) async {
    await prefs.setString(key, data);
  }

  static Future<String> getData() async {
    String? val = prefs.getString('data');
    return val!;
  }
}