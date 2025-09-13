import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:async';

import 'package:wms_app/utils/cookies_handler.dart';

final String apiAddress = "http://192.168.1.9:8080";

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
    final http.Response response = await http.get(url).timeout(const Duration(seconds: 10));
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
    String? cookie = await loadRawCookies();
    
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
      logger.i("Saving Cookies");
      await saveCookies(newCookies);
      logger.i("Cookies Saved");
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


APIResponseCode returnCodeToResponseCode(APIReturnType result) {
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

      logger.d("Server Error: ${response.statusCode}");
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

Future<APIResponseCode> loginUser(String username, String password) async {
  logger.i("Sending login request..");
  APIReturnType result = await post(
    "/user/login",
    jsonEncode(
      {
        "username": username,
        "password": password
      }
    )
  );

  return returnCodeToResponseCode(result);
}

Future<APIResponseCode> registerEmail(String email) async {
  logger.i("Sending register request for this email $email");
  APIReturnType result = await post(
    "/user/register/1",
    jsonEncode(
      {
        "email": email
      }
    )
  );

  return returnCodeToResponseCode(result);
}

Future<APIResponseCode> verifyEmail(String token) async {
  logger.i("Sending verification request");
  APIReturnType result = await post(
    "/user/register/2",
    jsonEncode(
      {
        "verification_token": token
      }
    )  
  );

  return returnCodeToResponseCode(result);
}

Future<APIResponseCode> createUser(String username, String password) async {
  logger.i("Sending create user request");
  APIReturnType result = await post(
    "/user/register/3",
    jsonEncode(
      {
        "username": username,
        "password": password
      }
    )
  );

  return returnCodeToResponseCode(result);
}