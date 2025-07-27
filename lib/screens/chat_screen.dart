import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillswap_flutter/providers/user_provider.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String matchId;
  final Map<String, dynamic> otherUser;

  const ChatScreen({super.key, required this.matchId, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final apiService = ApiService();
  final _scrollController = ScrollController();

  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final msgs = await apiService.getMessagesForMatch(widget.matchId);
    setState(() {
      messages = msgs;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final myUserId = context.read<UserProvider>().profile?['id'];
    if (myUserId == null) return;

    await apiService.sendMessage({
      'matchId': widget.matchId,
      'senderId': myUserId,
      'content': text,
    });

    _controller.clear();
    await _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherUser['name']}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: messages
                  .map(
                    (m) => ListTile(
                      title: Text(m['content'] ?? ''),
                      subtitle: Text(m['sentAt'] ?? ''),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
