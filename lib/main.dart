import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillswap_flutter/providers/swipe_provider.dart';
import 'providers/user_provider.dart';
import 'providers/match_provider.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/swipe_screen.dart';
import 'screens/user_profile_screen.dart';

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

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProvider>().profile;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillSwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userProfile == null
          ? const ProfileSetupScreen()
          : const SwipeScreen(),
      routes: {
        '/setup': (_) => const ProfileSetupScreen(),
        '/swipe': (_) => const SwipeScreen(),
        '/profile': (_) => const UserProfileScreen(),
      },
    );
  }
}
