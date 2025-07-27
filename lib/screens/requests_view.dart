import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  late Future<List<dynamic>> _matchesFuture;
  late String myUserId;

  @override
  void initState() {
    super.initState();
    myUserId = context.read<UserProvider>().profile?['id'];
    _loadMatches();
  }

  void _loadMatches() {
    _matchesFuture = ApiService().getMatchesForUser(myUserId);
  }

  Future<void> _handleMatchStatus(String matchId, String status) async {
    await ApiService().updateMatchStatus(matchId, status);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Request ${status.toLowerCase()}')));
    setState(() => _loadMatches());
  }

  Future<String?> _fetchLastMessage(String matchId) async {
    final messages = await ApiService().getMessagesForMatch(matchId);
    if (messages.isNotEmpty) {
      return messages.last['content'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Requests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
            ],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _matchesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final matches = snapshot.data!;
            final received = matches.where(
              (m) => m['user2']['id'] == myUserId && m['status'] == 'PENDING',
            );
            final sent = matches.where(
              (m) => m['user1']['id'] == myUserId && m['status'] == 'PENDING',
            );

            return TabBarView(
              children: [
                // RECEIVED
                ListView(
                  children: received.map((match) {
                    final other = match['user1'];
                    return FutureBuilder<String?>(
                      future: _fetchLastMessage(match['id']),
                      builder: (context, snapshot) {
                        final preview = snapshot.data ?? '';

                        return ListTile(
                          title: Text(other['name']),
                          subtitle: preview.isNotEmpty
                              ? Text(
                                  preview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text('Wants to connect'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    _handleMatchStatus(match['id'], 'ACCEPTED'),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _handleMatchStatus(match['id'], 'REJECTED'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                // SENT
                ListView(
                  children: sent.map((match) {
                    final other = match['user2'];
                    return FutureBuilder<String?>(
                      future: _fetchLastMessage(match['id']),
                      builder: (context, snapshot) {
                        final preview = snapshot.data ?? '';

                        return ListTile(
                          title: Text(other['name']),
                          subtitle: preview.isNotEmpty
                              ? Text(
                                  preview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text('No messages yet.'),
                          onTap: () {
                            // optionally: open chat screen
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
