import 'package:flutter/material.dart';
import 'package:skillswap_flutter/providers/user_provider.dart';
import 'package:skillswap_flutter/services/api_service.dart';
import '../../Signup/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await apiService.loginUser(email, password);
      // Assume user info received, save it with Provider or any state mgmt
      context.read<UserProvider>().setProfile(user);
      // Navigate to swipe screen
      Navigator.of(context).pushNamedAndRemoveUntil('/swipe', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _handleLogin, child: const Text("Login")),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            },
            child: const Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
