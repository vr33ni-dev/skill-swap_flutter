import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().profile;

    if (profile == null) {
      return const Scaffold(body: Center(child: Text('No profile found.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile['name'], style: const TextStyle(fontSize: 24)),
            Text(profile['location']),
            Text(profile['bio'] ?? ''),
            const SizedBox(height: 20),
            const Text('Skills I Can Offer:'),
            Wrap(
              spacing: 8,
              children: List.generate(
                profile['skillsOffered'].length,
                (i) => Chip(label: Text(profile['skillsOffered'][i])),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Skills I Need:'),
            Wrap(
              spacing: 8,
              children: List.generate(
                profile['skillsNeeded'].length,
                (i) => Chip(label: Text(profile['skillsNeeded'][i])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
