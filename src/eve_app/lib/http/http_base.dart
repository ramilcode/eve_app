// ignore_for_file: prefer_interpolation_to_compose_strings, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:dio/dio.dart';

import 'package:eve_app/config/api_config.dart';
import 'package:eve_app/http/app_api_exceptions.dart';
import 'package:eve_app/services/auth_service.dart';
import 'package:eve_app/utils/app_utils.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:http/http.dart' as http;

class HttpBase {
  static const int TIME_OUT_DURATION = 30;
  static String get baseUrl => ApiConfig.baseUrl;
  static String _token = "";
  static String _refreshToken = "";
  static bool tokenInParam = true;
  static bool printHeaders = false;

  static const int noConnectionStatusCode = 9999;
  static const int invalidTokenStatusCode = 9998; // TODO IN REAL APP
  static const int expiredTokenStatusCode = 9997; // TODO IN REAL APP
  static const String expiredTokenString = "Expired JWT Token";

  static String get token {
    return _token;
  }

  static String get refreshToken {
    return _refreshToken;
  }

  static Map<String, String> getHeaderParams({bool needUserApiToken = true}) {
    String tok = token.isNotEmpty ? token : "???";
    Map<String, String> headerMap = {"Content-Type": "application/json", "Authorization": "Bearer $tok"};
    if (!needUserApiToken) {
      headerMap.remove("Authorization");
    }
    return headerMap;
  }

  static void setTokenAndRefreshToken(String token, String refreshToken) {
    printGreen("setTokenAndRefreshToken: tokenChanged(${_token != token}), refreshTokenChanged(${_refreshToken != refreshToken})");
    _token = token;
    _refreshToken = refreshToken;
  }

  static _refreshTheToken() async {
    //in real app ask user to refresh the token here :
    // return await AuthService().userRefreshTheTokens();
  }

  static String _fullUri(String? api, String qparams) {
    if (api == null) {
      return baseUrl + qparams;
    }
    return baseUrl + api + qparams;
  }

  static String _createUriParams(Map<String, dynamic>? params) {
    String qparams = "";
    if (params != null) {
      params.forEach((key, value) {
        if (qparams.isEmpty) {
          qparams += "?$key=$value";
        } else {
          qparams += "&$key=$value";
        }
      });
    }
    return qparams;
  }

  //GET
  static Future<dynamic> _getOrDelete(String api,
      {required String method, bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    Stopwatch stopwatch = Stopwatch()..start();
    String qparams = _createUriParams(params);

    var uri = Uri.parse(_fullUri(api, qparams));
    try {
      var response = method == "get"
          ? await http.get(uri, headers: getHeaderParams(needUserApiToken: needUserApiToken)).timeout(Duration(seconds: customTimeOutInSeconds ?? TIME_OUT_DURATION))
          : await http.delete(uri, headers: getHeaderParams(needUserApiToken: needUserApiToken)).timeout(Duration(seconds: customTimeOutInSeconds ?? TIME_OUT_DURATION));
      // var breakhere = jsonDecode(response.body);
      xPrint("$method: $api ${response.statusCode} | ${stopwatch.elapsed.inMilliseconds}ms");
      // xPrint(response.body);
      if (printHeaders) xPrint("Headers: ${getHeaderParams(needUserApiToken: needUserApiToken)}");
      if ((response.statusCode == expiredTokenStatusCode) && allowTokenRefresh) {
        printYellow("Neeed to refresh token...");
        bool tokenGotRefreshed = await _refreshTheToken();
        if (tokenGotRefreshed) {
          return await _getOrDelete(api, method: method, needUserApiToken: needUserApiToken, allowTokenRefresh: false, params: params);
        } else {
          //only used when refreshing token
          throw AppHTTPException({
            "message": "Tokens erronés (erreur de refresh), veillez vous reconnecter.",
            "status_code": response.statusCode,
          }, response.request!.url.toString());
        }
      } else if (response.statusCode == invalidTokenStatusCode) {
        throw AppHTTPException({
          "message": "Tokens erronés, veillez vous reconnecter.",
          "status_code": response.statusCode,
        }, response.request!.url.toString());
      } else {
        return _processResponse(response);
      }
    } on SocketException {
      throw AppHTTPException({"message": "Problème connexion au serveur.", "status_code": noConnectionStatusCode}, uri.toString()); //No Internet connection
    } on TimeoutException {
      throw AppHTTPException({"message": "Délai d'attente dépassé", "status_code": noConnectionStatusCode}, uri.toString()); //API not responded in time
    }
  }

  static Future<dynamic> _postOrPutOrPatch(String api, dynamic payloadObj,
      {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, required String method, int? customTimeOutInSeconds}) async {
    Stopwatch stopwatch = Stopwatch()..start();
    String qparams = _createUriParams(params);

    var uri = Uri.parse(_fullUri(api, qparams));
    String payload = json.encode(payloadObj);
    // xPrint(uri);
    // xPrint("$method body: " + payloadObj.toString()); //payload
    try {
      http.Response response;
      if (method == "patch") {
        response = await http.patch(uri, headers: getHeaderParams(needUserApiToken: needUserApiToken), body: payload).timeout(Duration(seconds: customTimeOutInSeconds ?? TIME_OUT_DURATION));
      } else if (method == "put") {
        response = await http.put(uri, headers: getHeaderParams(needUserApiToken: needUserApiToken), body: payload).timeout(Duration(seconds: customTimeOutInSeconds ?? TIME_OUT_DURATION));
      } else {
        //post
        response = await http.post(uri, headers: getHeaderParams(needUserApiToken: needUserApiToken), body: payload).timeout(Duration(seconds: customTimeOutInSeconds ?? TIME_OUT_DURATION));
      }
      xPrint("$method: $api ${response.statusCode} | ${stopwatch.elapsed.inMilliseconds}ms");
      // xPrint("$uri");
      // xPrint("$method body: " + payloadObj.toString());
      if (payload.length < 300) xPrint("$method body: " + payloadObj.toString()); //payload
      if ((response.statusCode == expiredTokenStatusCode) && allowTokenRefresh) {
        printYellow("Neeed to refresh token...");
        bool tokenGotRefreshed = await _refreshTheToken();
        if (tokenGotRefreshed) {
          return await _postOrPutOrPatch(api, payload, needUserApiToken: needUserApiToken, allowTokenRefresh: false, params: params, method: method, customTimeOutInSeconds: customTimeOutInSeconds);
        } else {
          //only used when refreshing token
          throw AppHTTPException({
            "message": "Tokens erronés (erreur de refresh), veillez vous reconnecter.",
            "status_code": response.statusCode,
            // "error_code": needToRefreshTokenErrorCode
          }, response.request!.url.toString());
        }
      } else if (response.statusCode == invalidTokenStatusCode) {
        throw AppHTTPException({
          "message": "Tokens erronés, veillez vous reconnecter.",
          "status_code": response.statusCode,
          // "error_code": expiredTokenErrorCode,
        }, response.request!.url.toString());
      } else {
        return _processResponse(response);
      }
    } on SocketException {
      throw AppHTTPException({"message": "Problème connexion au serveur.", "status_code": noConnectionStatusCode}, uri.toString());
    } on TimeoutException {
      throw AppHTTPException({"message": "Délai d'attente dépassé", "status_code": noConnectionStatusCode}, uri.toString()); //API not responded in time
    }
  }

  static Future<dynamic> get(String api, {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    return _getOrDelete(api, method: "get", needUserApiToken: needUserApiToken, allowTokenRefresh: allowTokenRefresh, params: params, customTimeOutInSeconds: customTimeOutInSeconds);
  }

  static Future<dynamic> delete(String api, {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    return _getOrDelete(api, method: "delete", needUserApiToken: needUserApiToken, allowTokenRefresh: allowTokenRefresh, params: params, customTimeOutInSeconds: customTimeOutInSeconds);
  }

  static Future<dynamic> post(String api, dynamic payloadObj, {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    return _postOrPutOrPatch(api, payloadObj, needUserApiToken: needUserApiToken, allowTokenRefresh: allowTokenRefresh, params: params, method: "post", customTimeOutInSeconds: customTimeOutInSeconds);
  }

  static Future<dynamic> put(String api, dynamic payloadObj, {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    return _postOrPutOrPatch(api, payloadObj, needUserApiToken: needUserApiToken, allowTokenRefresh: allowTokenRefresh, params: params, method: "put", customTimeOutInSeconds: customTimeOutInSeconds);
  }

  static Future<dynamic> patch(String api, dynamic payloadObj, {bool needUserApiToken = true, bool allowTokenRefresh = true, Map<String, dynamic>? params, int? customTimeOutInSeconds}) async {
    return _postOrPutOrPatch(api, payloadObj,
        needUserApiToken: needUserApiToken, allowTokenRefresh: allowTokenRefresh, params: params, method: "patch", customTimeOutInSeconds: customTimeOutInSeconds);
  }

  static dynamic _processResponse(http.Response response) {
    int statusCode = response.statusCode;
    String urlWithoutParams = AppUtils.urlAndNetworkUtils.getUrlWithoutParams(response.request!.url.toString());
    switch (statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        // if (printReturns) printGreen(responseJson);
        return responseJson;
      case 204:
        return response.body.isEmpty ? "Succes" : response.body; // TODO CUSTOMIZE IN REAL APP
      case 404:
        throw AppHTTPException({"message": "URL Introuvable $urlWithoutParams", "status_code": statusCode}, urlWithoutParams);
      default: // TODO CUSTOMIZE IN REAL APP
        // dynamic errBody = response.body; //json.decode(utf8.decode(response.bodyBytes));
        try {
          var responseError = json.decode(utf8.decode(response.bodyBytes));
          printRed(response);
          if (responseError is String) {
            throw AppHTTPException({"message": responseError, "status_code": statusCode}, urlWithoutParams);
          } else {
            throw AppHTTPException({
              ...responseError,
              "status_code": statusCode,
            }, urlWithoutParams);
          }
        } on FormatException {
          throw AppHTTPException(
              // ignore: unnecessary_string_interpolations
              {"message": "${response.body}".length <= 100 ? response.body : "${response.reasonPhrase} : $statusCode", "status_code": statusCode},
              urlWithoutParams);
        }
    }
  }
}
