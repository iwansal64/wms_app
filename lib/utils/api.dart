import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

final String apiAddress = "http://127.0.0.1:8080";

final logger = Logger();

sealed class GetReturnType {}

class HTTPResponse extends GetReturnType {
  final http.Response response;
  HTTPResponse(this.response);
}

class HTTPError extends GetReturnType {
  final String errorMessage;
  HTTPError(this.errorMessage);
}

Future<GetReturnType> get(String endpoint) async {
  final url = Uri.parse(apiAddress+endpoint);

  try {
    final http.Response response = await http.get(url);
    return HTTPResponse(response);
  }
  catch(err) {
    logger.e("There's an error when trying to request to the API.");
    return HTTPError(err.toString());
  }
}

Future<GetReturnType> post(String endpoint, String body) async {
  final url = Uri.parse(apiAddress+endpoint);

  try {
    final http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
    return HTTPResponse(response);
  }
  catch(err) {
    logger.e("There's an error when trying to request to the API.");
    return HTTPError(err.toString());
  }
}



enum LoginResponseCode {
  unauthorized,
  authorized,
  rateLimited,
  serverError,
  error
}

Future<LoginResponseCode> loginUser(String username, String password) async {
  logger.i("API Address: $apiAddress");
  GetReturnType result = await post(
    "/user/login",
    jsonEncode(
      {
        "username": username,
        "password": password
      }
    )
  );

  switch (result) {
    case HTTPResponse(:var response):
      if(response.statusCode == 200) {
        logger.d("Successfully login");
        return LoginResponseCode.authorized;
      }
      else if(response.statusCode == 401) {
        logger.d("Unauthorized");
        return LoginResponseCode.unauthorized;
      }
      else if(response.statusCode == 429) {
        logger.d("Rate-limited");
        return LoginResponseCode.rateLimited;
      }

      logger.d("Server Error: ${response.statusCode}");
      return LoginResponseCode.serverError;
    case HTTPError(:var errorMessage):
      logger.e(errorMessage);
      return LoginResponseCode.error;
  }

}