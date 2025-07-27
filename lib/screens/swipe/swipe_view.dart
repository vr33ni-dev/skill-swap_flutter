import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/swipe_provider.dart';
import '../inbox_screen.dart';
import '../profile_view.dart';
import 'swipe_stack.dart';

class SwipeView extends StatefulWidget {
  const SwipeView({super.key});

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().profile;
      debugPrint('🔍 User in SwipeView: $user');
      if (user != null && user['id'] != null) {
        context.read<SwipeProvider>().loadUsers(user['id'], user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo Swipe',
            onPressed: () => context.read<SwipeProvider>().swipeBack(),
          ),
          IconButton(
            icon: const Icon(Icons.mail_outline),
            tooltip: 'Inbox',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InboxScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileView()),
              );
            },
          ),
        ],
      ),
      body: const SwipeStack(),
    );
  }
}
