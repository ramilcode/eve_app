import 'package:eve_app/constants/app_sizes.dart';
import 'package:eve_app/http/http_base.dart';
import 'package:eve_app/providers/app_theme_provider.dart';
import 'package:eve_app/screens/home_screen/home_screen.dart';
import 'package:eve_app/screens/login_screen/components/login_form_widget.dart';
import 'package:eve_app/services/auth_service.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:eve_app/widgets/buttons/light_dark_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    //call after build complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        skipLoginIfAlreadyLoggedIn();
      } catch (e) {
        printRed(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sWidth = size.width;

    return Scaffold(
      body: Stack(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: LightDarkModeButton(),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: AppSizes.calcScreenHorizontalPadding(sWidth)), child: const LoginFormWidget(isRelog: false)),
        ],
      ),
    );
  }

  Future<void> skipLoginIfAlreadyLoggedIn() async {
    xPrint("skipLoginIfAlreadyLoggedIn");
    AuthService().loadPreviousTokens();
    if (HttpBase.token.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }
}
