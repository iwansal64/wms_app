import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms_app/utils/api.dart';

class AppStorage {
  static Future<void> saveString(String key, String value) async {
    logger.i("[API] Saving $key into storage");
    final prefs = await SharedPreferences.getInstance();
    if(value.isEmpty) {
      await prefs.remove(key);
      return;
    }
    await prefs.setString(key, value);
  }

  static Future<void> removeString(String key) async {
    await saveString(key, "");
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

