import 'package:eve_app/providers/guest_provider.dart';
import 'package:eve_app/services/shared_prefs_service.dart';
import 'package:eve_app/utils/print_utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppStateHandler {
  static Future<void> initialiseApp({bool forceInit = false}) async {
    xPrint("Init app (force: $forceInit)");
    await SharedPrefsService().initSharedPrefsService();
  }

  static void resetAppState(BuildContext context) {
    Provider.of<GuestProvider>(context, listen: false).reset();
  }
}
