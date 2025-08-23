import 'package:flutter/material.dart';
import 'package:skillswap_flutter/screens/welcome/components/login_signup_btn.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SizedBox(width: 300, child: LoginAndSignupBtn())),
    );
  }
}
