import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/swipe_provider.dart';
import 'profile_card.dart';

class SwipeStack extends StatelessWidget {
  const SwipeStack({super.key});

  @override
  Widget build(BuildContext context) {
    final swipeProvider = context.watch<SwipeProvider>();
    final current = swipeProvider.currentUser;

    if (current == null) {
      return const Center(child: Text('No users to show 😢'));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileCard(profile: current),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              iconSize: 40,
              onPressed: swipeProvider.swipeLeft,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.green),
              iconSize: 40,
              onPressed: swipeProvider.swipeRight,
            ),
          ],
        ),
      ],
    );
  }
}
