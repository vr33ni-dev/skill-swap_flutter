import 'package:flutter/material.dart';
import 'package:skillswap_flutter/screens/profile_setup_screen.dart';
import '../../login/login_screen.dart';
import '../../signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text("Login"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
            );
          },
          child: const Text("Sign Up"),
        ),
      ],
    );
  }
}
