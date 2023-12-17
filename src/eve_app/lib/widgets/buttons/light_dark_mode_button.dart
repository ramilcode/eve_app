import 'package:eve_app/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LightDarkModeButton extends StatelessWidget {
  const LightDarkModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemeProvider appThemeProvider = Provider.of<AppThemeProvider>(context);
    bool isDarkTheme = appThemeProvider.isDarkTheme;
    return IconButton(
        onPressed: () {
          appThemeProvider.setIsDarkTheme();
        },
        icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode));
  }
}
