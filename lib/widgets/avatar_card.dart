import 'package:flutter/material.dart';

class AvatarCard extends StatelessWidget {
  final String name;
  final String bio;
  final String location;
  final String avatarUrl;

  const AvatarCard({
    super.key,
    required this.name,
    required this.bio,
    required this.location,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(height: 10),
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        Text(location, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text(bio, textAlign: TextAlign.center),
      ],
    );
  }
}
