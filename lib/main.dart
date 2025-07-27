import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillswap_flutter/providers/swipe_provider.dart';
import 'package:skillswap_flutter/screens/login/login_screen.dart';
import 'package:skillswap_flutter/screens/main_screen.dart';
import 'package:skillswap_flutter/screens/profile_view.dart';
import 'package:skillswap_flutter/screens/welcome/welcome_screen.dart';
import 'providers/user_provider.dart';
import 'providers/match_provider.dart';
import 'screens/profile_setup_screen.dart';

void main() {
  print('App started');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => SwipeProvider()),
      ],
      child: const SkillSwapApp(),
    ),
  );
}

class SkillSwapApp extends StatefulWidget {
  const SkillSwapApp({super.key});

  @override
  State<SkillSwapApp> createState() => _SkillSwapAppState();
}

class _SkillSwapAppState extends State<SkillSwapApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userProvider = context.read<UserProvider>();
    await userProvider
        .loadProfile(); // You need to create this async method in UserProvider
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show a loading spinner while profile is loading
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final userProfile = context.watch<UserProvider>().profile;
    print('userProfile: $userProfile');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillSwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userProfile == null ? const WelcomeScreen() : const MainScreen(),
      routes: {
        '/setup': (_) => const WelcomeScreen(),
        '/swipe': (_) => const MainScreen(),
        '/profile': (_) => const ProfileView(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const ProfileSetupScreen(),
      },
    );
  }
}
