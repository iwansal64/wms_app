
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:wms_app/env/env.dart';
import 'package:wms_app/state.dart';
import 'dart:convert';
import 'dart:async';

import 'package:wms_app/utils/cookies_handler.dart';
import 'package:wms_app/utils/model.dart';
import 'package:wms_app/utils/storage_handler.dart';


final logger = Logger();

sealed class APIReturnType {}

class APIResponse extends APIReturnType {
  final http.Response response;
  APIResponse(this.response);
}

class APIError extends APIReturnType {
  final String errorMessage;
  APIError(this.errorMessage);
}

class APITimeout extends APIReturnType {}
class APISocketError extends APIReturnType {}

Future<APIReturnType> get(String endpoint) async {
  final url = Uri.parse(apiAddress+endpoint);

  try {
    String? cookie = await AppStorage.getString("cookies");
    
    final http.Response response = await http.get(
      url,
      headers: {
        "Cookie": cookie ?? ""
      }
    ).timeout(const Duration(seconds: 30));

    String? newCookies = response.headers["set-cookie"];
    if(newCookies != null) {
      logger.i("[API] Saving Cookies");
      await saveCookies(newCookies);
      logger.i("[API] Cookies Saved");
    }
    return APIResponse(response);
  }
  catch(err) {
    logger.e("There's an error when trying to request to the API.");
    return APIError(err.toString());
  }
}

Future<APIReturnType> post(String endpoint, String body) async {
  final url = Uri.parse(apiAddress+endpoint);

  try {
    String? cookie = await AppStorage.getString("cookies");
    
    final http.Response response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Cookie": cookie ?? ""
      },
      body: body
    ).timeout(const Duration(seconds: 10));

    String? newCookies = response.headers["set-cookie"];
    if(newCookies != null) {
      logger.i("[API] Saving Cookies");
      await saveCookies(newCookies);
      logger.i("[API] Cookies Saved");
    }

    return APIResponse(response);
  }
  on TimeoutException catch (_) {
    return APITimeout();
  }
  on SocketException catch (_) {
    return APISocketError();
  }
  on Exception catch (err) {
    return APIError(err.toString());
  }
}



enum APIResponseCode {
  ok,
  unauthorized,
  rateLimited,
  serverError,
  conflict,
  timeout,
  socketError,
  error
}


APIResponseCode returnTypeToResponseCode(APIReturnType result) {
  switch (result) {
    case APIResponse(:var response):
      if(response.statusCode == 200) {
        return APIResponseCode.ok;
      }
      else if(response.statusCode == 401) {
        return APIResponseCode.unauthorized;
      }
      else if(response.statusCode == 429) {
        return APIResponseCode.rateLimited;
      }
      else if(response.statusCode == 409) {
        return APIResponseCode.conflict;
      }

      logger.i("[API] Server Error: ${response.statusCode}");
      return APIResponseCode.serverError;
    case APIError(:var errorMessage):
      logger.e(errorMessage);
      return APIResponseCode.error;
    case APITimeout():
      return APIResponseCode.timeout;
    case APISocketError():
      return APIResponseCode.socketError;
  }

}


//- ============================ API Features =============================

//? Login User
Future<APIResponseCode> loginUser(String username, String password) async {
  logger.i("[API] Sending login request..");
  APIReturnType result = await post(
    "/user/login",
    jsonEncode(
      {
        "username": username,
        "password": password
      }
    )
  );

  return returnTypeToResponseCode(result);
}

//? Register Email
Future<APIResponseCode> registerEmail(String email) async {
  logger.i("[API] Sending register request for this email $email");
  APIReturnType result = await post(
    "/user/register/1",
    jsonEncode(
      {
        "email": email
      }
    )
  );

  return returnTypeToResponseCode(result);
}

//? Verify Token for Email Verification
Future<APIResponseCode> verifyEmail(String token) async {
  logger.i("[API] Sending verification request");
  APIReturnType result = await post(
    "/user/register/2",
    jsonEncode(
      {
        "verification_token": token
      }
    )  
  );

  return returnTypeToResponseCode(result);
}

//? Create User
Future<APIResponseCode> createUser(String username, String password) async {
  logger.i("[API] Sending create user request");
  APIReturnType result = await post(
    "/user/register/3",
    jsonEncode(
      {
        "username": username,
        "password": password
      }
    )
  );

  return returnTypeToResponseCode(result);
}

//? Get Device Data
sealed class GetDeviceReturnType {}

class DevicesData extends GetDeviceReturnType {
  final List<Device> devices;
  DevicesData(this.devices);
}

class NoDeviceData extends GetDeviceReturnType {
  final APIResponseCode responseCode;
  NoDeviceData(this.responseCode);
}

Future<GetDeviceReturnType> getDevices() async {
  logger.i("[API] Getting device data");
  APIReturnType result = await get("/device");
  switch(result) {
    case APIResponse(:var response):
      if(response.statusCode == 200) {
        List<Device> devicesData = [];
        final Map<String, dynamic> data = jsonDecode(response.body);
        if(!data.containsKey("devices")) {
          logger.e("The returned value from server doesn't contains devices key");
          return NoDeviceData(APIResponseCode.serverError);
        }

        for(Map<String, dynamic> device in data["devices"]) {
          Device deviceData = Device.fromJson(device);
          devicesData.add(deviceData);
        }

        AppState.devicesState.value = devicesData;

        

        return DevicesData(devicesData);
      }
      else {
        return NoDeviceData(returnTypeToResponseCode(result));
      }
    default:
      return NoDeviceData(returnTypeToResponseCode(result));
  }
}

Future<void> logout() async {
  await removeLoginCookie();
}