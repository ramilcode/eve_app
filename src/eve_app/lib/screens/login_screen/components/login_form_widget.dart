import 'package:flutter/material.dart';

import 'package:eve_app/screens/home_screen/home_screen.dart';
import 'package:eve_app/services/auth_service.dart';

class LoginFormWidget extends StatefulWidget {
  final bool isRelog;
  const LoginFormWidget({
    Key? key,
    required this.isRelog,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool passwordIsVisible = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loginIsLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sHeight = size.height;
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "I N V I T A T I O N S",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            minRadius: 0.1 * sHeight,
            maxRadius: 0.1 * sHeight, //Change the background of the circle
            child: const Image(
              image: AssetImage('assets/images/invitations_logo.png'),
              fit: BoxFit.cover, // Change the fit as needed
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Identifiant',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Identifiant requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: !passwordIsVisible,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              suffixIcon: IconButton(
                icon: Icon(
                  passwordIsVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    passwordIsVisible = !passwordIsVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mot de passe requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: loginIsLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loginIsLoading = true;
                            });
                            await login();
                            setState(() {
                              loginIsLoading = false;
                            });
                          }
                        },
                  child: loginIsLoading ? const Text("Connexion en cours ...") : const Text('Login'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    // Add your login logic here
    String username = usernameController.text;
    String password = passwordController.text;
    // Add your authentication logic here
    bool loginSuccess = await AuthService().login(context, username: username, password: password);
    if (loginSuccess && context.mounted) {
      if (widget.isRelog) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }
}
