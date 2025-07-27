import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final List offered = profile['skillsOffered'] ?? [];
    final List needed = profile['skillsNeeded'] ?? [];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profile['photoUrl'] != null
                  ? NetworkImage(profile['photoUrl'])
                  : null,
              child: profile['photoUrl'] == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(profile['location'] ?? 'No location'),

            const SizedBox(height: 20),
            if (offered.isNotEmpty) ...[
              const Text(
                "Offers:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: offered
                    .map((skill) => Chip(label: Text(skill['name'])))
                    .toList(),
              ),
              const SizedBox(height: 10),
            ],

            if (needed.isNotEmpty) ...[
              const Text(
                "Needs:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: needed
                    .map((skill) => Chip(label: Text(skill['name'])))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
