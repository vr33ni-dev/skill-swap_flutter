import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';
import 'chat_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myUserId = context.read<UserProvider>().profile?['id'];
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Inbox')),
      body: FutureBuilder(
        future: apiService.getMatchesForUser(myUserId),
        builder: (context, snapshot) {
          debugPrint('Matches for user $myUserId: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text('No matches yet!'));
          }

          final matches = snapshot.data as List<dynamic>;
          // Only show accepted matches
          final acceptedMatches = matches
              .where((match) => match['status'] == 'ACCEPTED')
              .toList();

          return ListView(
            children: acceptedMatches.map((match) {
              final status = match['status'];
              final other = match['user1']['id'] == myUserId
                  ? match['user2']
                  : match['user1'];

              return ListTile(
                title: Text(other['name'] ?? 'Unknown'),
                subtitle: const Text('Tap to chat'),
                trailing: const Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(matchId: match['id'], otherUser: other),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
