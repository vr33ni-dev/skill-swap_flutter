import 'package:flutter/material.dart';
import 'package:skillswap_flutter/screens/chat_screen.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user id from UserProvider
    final userId = context.read<UserProvider>().profile?['id'];
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getMatchesForUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load matches'));
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final userId = context.read<UserProvider>().profile?['id'];

              // Assuming match has 'user1' and 'user2' objects with 'id' and 'name'
              final user1 = match['user1'];
              final user2 = match['user2'];

              final otherUser = user1['id'] == userId ? user2 : user1;

              return ListTile(
                title: Text(otherUser['name'] ?? 'Unknown'),
                trailing: IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    debugPrint('Open chat with ${otherUser['name']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          matchId: match['id'],
                          otherUser: otherUser,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
