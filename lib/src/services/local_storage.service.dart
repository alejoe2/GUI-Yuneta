part of './services.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> configPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
