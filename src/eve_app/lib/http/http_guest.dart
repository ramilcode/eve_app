import 'dart:async';
import 'package:eve_app/http/app_api_exceptions.dart';
import 'package:eve_app/http/http_base.dart';
import 'package:eve_app/models/guest.dart';
import 'package:eve_app/services/auth_service.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:eve_app/widgets/popups/toast.dart';
import 'package:flutter/material.dart';

class HttpGuest {
  static const String _api = "/guests";

  ///returns list of guests from API
  static Future<(bool, List<Guest>?)> getGuests(BuildContext? context, {printResponse = false}) async {
    // Map<String, String> params = {"a": "b", "c": "d"};
    bool hadApiError = true;
    var response = await HttpBase.get(_api, params: {}).catchError((error) {
      printRed(error.toString());
      if (context != null) {
        late AppException appException;
        if (error is! AppHTTPException) {
          appException = AppException(message: "$error");
        } else {
          appException = error;
        }

        ///in real app we use only status code, for this example we use error message
        if (appException.statusCode == HttpBase.expiredTokenStatusCode || "${appException.message}".contains(HttpBase.expiredTokenString)) {
          AuthService.askForRelog(context);
        } else if (appException.statusCode == HttpBase.noConnectionStatusCode) {
          AppToast.showToast("Pas de connexion : Synchronisation Invités échouée.", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        } else {
          AppToast.showToast("Erreur HTTP :\n${appException.message}", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        }
      }
    });

    if (response != null && response["hydra:member"] != null) {
      // printGreen(response);
      hadApiError = false;
      List<Guest> guests = Guest.fromMapList(response["hydra:member"]);
      if (printResponse) printGreen(response);
      return (hadApiError, guests);
    }

    return (hadApiError, null);
  }

  static Future<(bool, Guest?)> putGuest(BuildContext? context, {required Guest guestToPut, printResponse = false}) async {
    String api = "/guests/${guestToPut.id}";
    Map<String, dynamic> payload = guestToPut.toMap();
    payload.remove("id");
    bool hadApiError = true;
    var response = await HttpBase.put(api, payload, params: null).catchError((error) {
      printRed(error.toString());
      if (context != null) {
        late AppException appException;
        if (error is! AppHTTPException) {
          appException = AppException(message: "$error");
        } else {
          appException = error;
        }

        ///in real app we use only status code, for this example we use error message
        if (appException.statusCode == HttpBase.expiredTokenStatusCode || "${appException.message}".contains(HttpBase.expiredTokenString)) {
          AuthService.askForRelog(context);
        } else if (appException.statusCode == HttpBase.noConnectionStatusCode) {
          AppToast.showToast("Pas de connexion : Modification de l'invité échouée.", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        } else {
          AppToast.showToast("Erreur HTTP :\n${appException.message}", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        }
      }
    });

    if (response != null) {
      if (printResponse) printGreen(response);
      hadApiError = false;
      Guest updatedGuest = Guest.fromMap(response);

      return (hadApiError, updatedGuest);
    }

    return (hadApiError, null);
  }

  static Future<(bool, Guest?)> postGuest(BuildContext? context, {required Guest guestToPost, printResponse = false}) async {
    String api = "/guests";
    Map<String, dynamic> payload = guestToPost.toMap();
    payload.remove("id");

    bool hadApiError = true;
    var response = await HttpBase.post(api, payload).catchError((error) {
      printRed(error.toString());
      if (context != null) {
        late AppException appException;
        if (error is! AppHTTPException) {
          appException = AppException(message: "$error");
        } else {
          appException = error;
        }

        ///in real app we use only status code, for this example we use error message
        if (appException.statusCode == HttpBase.expiredTokenStatusCode || "${appException.message}".contains(HttpBase.expiredTokenString)) {
          AuthService.askForRelog(context);
        } else if (appException.statusCode == HttpBase.noConnectionStatusCode) {
          AppToast.showToast("Pas de connexion : Ajout de l'invité échouée.", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        } else {
          AppToast.showToast("Erreur HTTP :\n${appException.message}", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        }
      }
    });

    if (response != null) {
      if (printResponse) printGreen(response);
      hadApiError = false;
      Guest addedGuest = Guest.fromMap(response);

      return (hadApiError, addedGuest);
    }

    return (hadApiError, null);
  }

  static Future<(bool, dynamic)> deleteGuest(BuildContext? context, {required Guest guestToDelete, printResponse = false}) async {
    String api = "/guests/${guestToDelete.id}";

    bool hadApiError = true;
    var response = await HttpBase.delete(api).catchError((error) {
      printRed(error.toString());
      if (context != null) {
        late AppException appException;
        if (error is! AppHTTPException) {
          appException = AppException(message: "$error");
        } else {
          appException = error;
        }

        ///in real app we use only status code, for this example we use error message
        if (appException.statusCode == HttpBase.expiredTokenStatusCode || "${appException.message}".contains(HttpBase.expiredTokenString)) {
          AuthService.askForRelog(context);
        } else if (appException.statusCode == HttpBase.noConnectionStatusCode) {
          AppToast.showToast("Pas de connexion : Modification de l'invité échouée.", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        } else {
          AppToast.showToast("Erreur HTTP :\n${appException.message}", context: context, colorBg: Theme.of(context).colorScheme.error, toastDurationEnum: ToastDurationEnum.long);
        }
      }
    });

    if (response != null) {
      if (printResponse) printGreen(response);
      hadApiError = false;

      return (hadApiError, "$response");
    }

    return (hadApiError, null);
  }
}
