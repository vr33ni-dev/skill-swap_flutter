import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().profile;

    final skillsOffered = List<String>.from(profile?['skillsOffered'] ?? []);
    final skillsNeeded = List<String>.from(profile?['skillsNeeded'] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: profile == null
            ? const Text('No profile found')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile['name'] ?? 'No name',
                    style: const TextStyle(fontSize: 24),
                  ),
                  if (profile['bio'] != null)
                    Text(profile['bio'], style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Skills Offered'),
                  Wrap(
                    spacing: 6,
                    children: skillsOffered
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Skills Needed'),
                  Wrap(
                    spacing: 6,
                    children: skillsNeeded
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  ),
                ],
              ),
      ),
    );
  }
}
