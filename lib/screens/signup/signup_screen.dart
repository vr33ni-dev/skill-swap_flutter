import 'package:flutter/material.dart';
import 'package:skillswap_flutter/screens/signup/components/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(padding: EdgeInsets.all(16.0), child: SignUpForm()),
      ),
    );
  }
}
