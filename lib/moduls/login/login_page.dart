import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:tes_synapsisid/moduls/a_page/a_page.dart';
import 'package:tes_synapsisid/moduls/home_page.dart';

import '../../database/user/auth_provider.dart';

class LoginPage extends StatefulWidget {
  final AuthProvider authProvider;
  const LoginPage({super.key, required this.authProvider});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Synapsis.id',
      onLogin: (loginData) {
        return widget.authProvider.login(loginData.name, loginData.password);
      },
      onSignup: (loginData) {
        return widget.authProvider.register(loginData.name!, loginData.password!);
      },
      onRecoverPassword: (_) {
        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      },
    );
  }
}