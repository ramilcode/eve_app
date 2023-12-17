import 'package:eve_app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

abstract class AppDialog extends StatelessWidget {
  const AppDialog({super.key});
  static void showDialogAllCustom(
      {required BuildContext contextParent,
      String? title,
      required Widget content,
      String? textButton,
      String textButtonValidR = "Retour",
      Color? colorButton,
      Color? colorButtonValidR,
      Function? onPressCustom,
      Function? onPressCustomValidR,
      bool barrierDismissible = true,
      List<Widget>? actions}) {
    showDialog(
      context: contextParent,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          titlePadding: title == null ? const EdgeInsets.all(8) : const EdgeInsets.all(20),
          title: title == null
              ? Container()
              : Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
          content: Padding(
            padding: const EdgeInsets.only(top: AppSizes.dialogPadding / 2, bottom: AppSizes.dialogPadding),
            child: content,
          ),
          actions: actions ??
              [
                if (textButton != null && textButton != "") ...[
                  TextButton(
                    child: Text(
                      textButton,
                      style: TextStyle(
                        color: colorButton ?? Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onPressCustom != null) onPressCustom();
                    },
                  ),
                ],
                TextButton(
                  child: Text(
                    textButtonValidR,
                    style: TextStyle(
                      color: colorButtonValidR ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPressCustomValidR != null) onPressCustomValidR();
                  },
                ),
              ],
        );
      },
    );
  }
}
