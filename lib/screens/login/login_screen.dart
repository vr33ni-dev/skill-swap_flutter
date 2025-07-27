import 'package:flutter/material.dart';
import 'components/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: LoginForm()),
      ),
    );
  }
}
