import 'package:shared_preferences/shared_preferences.dart';
import 'package:wms_app/utils/storage_handler.dart';

//? Convert String Cookies Into Mapped
Map<String, Map<String, String>> mapCookies(String cookies) {
  if(!cookies.contains("=")) return {};

  List<List<String>> cookiesSplitted = cookies.split(",").map((element) => element.split(";")).toList();
  Map<String, Map<String, String>> result = {};

  for(List<String> cookieData in cookiesSplitted) {
    List<List<String>> keyValuePairs = cookieData.map((data) => data.split("=")).toList();
    String cookieKey = keyValuePairs[0][0];

    result[cookieKey] = {
      "value": keyValuePairs[0][1]
    };
    
    for (List<String> keyValue in keyValuePairs.getRange(1, keyValuePairs.length)) {
      result[cookieKey]?[keyValue[0]] = keyValue.length > 1 ? keyValue[1] : "";
    }
  }

  return result;
}

//? Convert Mapped Cookies Into String
String unmapCookies(Map<String, Map<String, String>> mappedCookies) {
  if(mappedCookies.isEmpty) return "";
  
  String result = "";
  for(var cookieData in mappedCookies.entries.toList()) {
    result += "${cookieData.key}=${cookieData.value["value"]};";
  }
  
  return result.substring(0, result.length-1);
}




//? LOAD COOKIES
Future<Map<String, Map<String, String>>?> loadCookies() async {
  final prefs = await SharedPreferences.getInstance();
  String? cookies = prefs.getString('cookies');
  if(cookies != null) {
    return mapCookies(cookies);
  }
  return null;
}

//? SAVE COOKIES
Future<void> saveCookies(String cookies) async {
  await AppStorage.saveString("cookies", "");
  Map<String, Map<String, String>>? storedCookies = await loadCookies();
  if(storedCookies == null) {
    Map<String, Map<String, String>> fetched = mapCookies(cookies);
    String result = unmapCookies(fetched);
    await AppStorage.saveString("cookies", result);
    return;
  }
  
  Map<String, Map<String, String>> addedCookies = mapCookies(cookies);
  for (var element in addedCookies.entries) {
    storedCookies[element.key] = element.value;
  }
  String result = unmapCookies(storedCookies);
  await AppStorage.saveString("cookies", result);
}

//? SAVE COOKIES
Future<void> removeLoginCookie() async {
  // Get the current cookies
  Map<String, Map<String, String>> cookies = await loadCookies() ?? {};
  if(!cookies.containsKey("access_token")) return;

  // Remove the token
  cookies.remove("access_token");

  // Save back the cookies
  saveCookies(unmapCookies(cookies));
}