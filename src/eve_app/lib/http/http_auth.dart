import 'dart:async';

import 'package:eve_app/http/app_api_exceptions.dart';
import 'package:eve_app/http/http_base.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:eve_app/widgets/popups/toast.dart';
import 'package:flutter/material.dart';

class HttpAuth {
  static Future<Map<String, dynamic>?> httpLogin({required String username, required String password, BuildContext? context}) async {
    String loginApi = "/login";

    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    final response = await HttpBase.post(loginApi, body, needUserApiToken: false, allowTokenRefresh: false, params: {}).catchError((error) {
      printRed(error);
      if (context != null) {
        late AppException appException;
        if (error is! AppHTTPException) {
          appException = AppException(message: "$error");
        } else {
          appException = error;
        }

        if (appException.errorCode == HttpBase.noConnectionStatusCode) {
          AppToast.showToast("Pas connexion au serveur.");
        } else {
          AppToast.showToast("Erreur d'authentification : ${appException.message}", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        }
      }
    });
    if (response != null) {
      printGreen(response);
      if (response != null && response["token"] != null) {
        return {
          "token": response["token"],
          // "refresh_token": response["refresh_token"],
        };
      }
    }
    return null;
  }
}
