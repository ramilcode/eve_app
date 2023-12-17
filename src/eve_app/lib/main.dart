import 'package:eve_app/overrides/my_custom_scroll_behaviour.dart';
import 'package:eve_app/providers/app_theme_provider.dart';
import 'package:eve_app/providers/guest_provider.dart';

import 'package:eve_app/screens/login_screen/login_screen.dart';
import 'package:eve_app/services/shared_prefs_service.dart';
import 'package:eve_app/state/app_state_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefsService().initSharedPrefsService();
  await AppStateHandler.initialiseApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GuestProvider()),
    ChangeNotifierProvider(create: (_) => AppThemeProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AppThemeProvider>(context, listen: false); //init AppThemeProvider
    bool isDarkTheme = context.select((AppThemeProvider appThemeProvider) => appThemeProvider.isDarkTheme);
    return MaterialApp(
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        // brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.brown.shade50,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown, brightness: Brightness.dark),
      ),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MyCustomScrollBehavior(),
      home: const LoginScreen(),
    );
  }
}
