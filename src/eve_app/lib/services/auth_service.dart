import 'package:eve_app/http/http_auth.dart';
import 'package:eve_app/http/http_base.dart';
import 'package:eve_app/screens/login_screen/components/login_form_widget.dart';
import 'package:eve_app/services/shared_prefs_service.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:eve_app/widgets/popups/app_dialog.dart';
import 'package:flutter/material.dart';

class AuthService {
  bool isInitialized = false;
  static bool askedForRelog = false; //so we dont ask to relog multiple times

  AuthService._privateConstructor();

  static final AuthService _instance = AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  ///returns true on login success
  Future<bool> login(BuildContext context, {required String username, required String password}) async {
    printYellow("Authservice: userLogin");
    if (context.mounted) {
      Map<String, dynamic>? newTokens = await HttpAuth.httpLogin(username: username, password: password, context: context);
      if (newTokens == null) return false;
      updateTokens(newToken: newTokens["token"], newRefreshToken: newTokens["refresh_token"]);
      return true;
    }

    return false;
  }

  Future<void> userDisconnect({BuildContext? context}) async {
    if (context != null) {
      AppDialog.showDialogAllCustom(
          contextParent: context,
          title: "Déconnexion",
          textButtonValidR: "Déconnecter",
          textButton: "Annuler",
          colorButtonValidR: Theme.of(context).colorScheme.error,
          colorButton: Theme.of(context).colorScheme.onSurface,
          content: const Text(
            "Voulez-vous vraiment vous déconnecter ?",
            // textAlign: TextAlign.center,
          ),
          onPressCustomValidR: () async {
            updateTokens();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          });
    } else {
      // userProvider.reset();
    }
  }

  ///updates token inside shared prefs and httpBase
  void updateTokens({String? newToken, String? newRefreshToken}) {
    printYellow("Authservice: updateTokens");
    // xPrint("Old token: ${HttpBase.token}");
    HttpBase.setTokenAndRefreshToken(newToken ?? "", newRefreshToken ?? "");
    if (newToken == null || newToken.isEmpty) {
      SharedPrefsService().removeSharedPrefByKey("token");
    } else {
      SharedPrefsService().setSharedPref("token", newToken);
    }
    if (newRefreshToken == null || newRefreshToken.isEmpty) {
      SharedPrefsService().removeSharedPrefByKey("refreshToken");
    } else {
      SharedPrefsService().setSharedPref("refreshToken", newRefreshToken);
    }
    // xPrint("New token: ${HttpBase.token}");
  }

  void loadPreviousTokens() {
    String? oldToken = SharedPrefsService().getSharedPref("token");
    // String? oldRefreshToken = SharedPrefsService().getSharedPref("refreshToken");
    if (oldToken != null) {
      xPrint("User was connected.");
      HttpBase.setTokenAndRefreshToken(oldToken, "");

      // HttpBase.headerParams["Authorization"] = "Bearer $oldToken";
    } else {
      xPrint("User was not connected.");
    }
  }

  static Future<void> askForRelog(BuildContext context) async {
    if (!askedForRelog) {
      askedForRelog = true;
      Future.delayed(const Duration(seconds: 5)).then((_) {
        askedForRelog = false;
      });
      AppDialog.showDialogAllCustom(
        barrierDismissible: false,
        contextParent: context,
        title: "Session expirée, veuillez vous reconnecter :",
        // textButtonValidR: "Me reconnecter",
        // textButton: "Passer en mode hors ligne",
        // textButton: "Ignorer",
        // colorButtonValidR: PmbColors.appMainColor,
        content: const LoginFormWidget(
          isRelog: true,
        ),
      );
    }
  }

  void printTokens() {
    xPrint("HttpToken: ${HttpBase.token}");
    xPrint("HttpRefreshToken: ${HttpBase.refreshToken}");
    xPrint("SharedPrefToken: ${SharedPrefsService().getSharedPref("token")}");
    xPrint("SharedPrefRefreshToken: ${SharedPrefsService().getSharedPref("refreshToken")}");
  }
}
