import 'package:eve_app/utils/print_utils.dart';

import 'package:flutter/material.dart';

enum ToastDurationEnum {
  short,
  medium,
  long,
}

extension DurationEnumExtension on ToastDurationEnum {
  Duration get duration {
    switch (this) {
      case ToastDurationEnum.short:
        return const Duration(milliseconds: 1000);
      case ToastDurationEnum.medium:
        return const Duration(milliseconds: 2000);
      case ToastDurationEnum.long:
        return const Duration(milliseconds: 4000);
      default:
        return const Duration(milliseconds: 1500);
    }
  }
}

class AppToast {
  static showToast(String contentText,
      {BuildContext? context, Color? colorBg, Color? colorText, ToastDurationEnum toastDurationEnum = ToastDurationEnum.short, bool forceSnackBar = true, String position = "snackbar"}) {
    if (context == null) {
      printYellow("Toast without context");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: colorBg == Colors.red
          ? SelectableText(
              contentText,
              style: TextStyle(color: colorText, fontSize: 12.0),
            )
          : Text(
              contentText,
              style: TextStyle(color: colorText, fontSize: 12.0),
            ),
      duration: toastDurationEnum.duration,
      backgroundColor: colorBg,
    ));
  }
}
