import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SwipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _users = [];
  int _currentIndex = 0;

  List<Map<String, dynamic>> get users => _users;
  Map<String, dynamic>? get currentUser =>
      (_currentIndex < _users.length) ? _users[_currentIndex] : null;

  List<Map<String, dynamic>> _allFetchedUsers = [];
  String myUserId = '';
  Map<String, dynamic> myProfile = {};

  String _filterMode = 'all'; // 'all' or 'relevant'
  String get filterMode => _filterMode;

  void setFilterMode(String mode) {
    _filterMode = mode;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_filterMode == 'all') {
      _users = _allFetchedUsers.where((u) => u['id'] != myUserId).toList();
    } else {
      final myOffered = List<String>.from(myProfile['skillsOffered'] ?? []);
      final myNeeded = List<String>.from(myProfile['skillsNeeded'] ?? []);

      _users = _allFetchedUsers
          .where((u) {
            final offered = List<String>.from(u['skillsOffered'] ?? []);
            final needed = List<String>.from(u['skillsNeeded'] ?? []);
            return offered.any(myNeeded.contains) ||
                needed.any(myOffered.contains);
          })
          .where((u) => u['id'] != myUserId)
          .toList();
    }

    _currentIndex = 0;
  }

  Future<void> loadUsers(String userId, Map<String, dynamic> profile) async {
    myUserId = userId;
    myProfile = profile;

    try {
      final allUsers = await _apiService.getAvailableUsers(userId);
      final matches = await _apiService.getMatchesForUser(userId);

      final blockedIds = matches
          .map<String>(
            (m) => m['user1']['id'] == userId
                ? m['user2']['id']
                : m['user1']['id'],
          )
          .toSet();

      final swipable = allUsers
          .where((u) => u['id'] != userId && !blockedIds.contains(u['id']))
          .toList();

      _allFetchedUsers = allUsers; // optionally store full list
      _users = swipable;
      _currentIndex = 0;
      _applyFilter(); // respects current filter
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading swipable users: $e');
    }
  }

  void swipeLeft() {
    _moveNext();
  }

  void swipeRight(BuildContext context) async {
    if (_currentIndex >= _users.length || myProfile['id'] == null) return;

    final Map<String, dynamic> otherUser = _users[_currentIndex];

    // Prompt for message
    final message = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Send a message to ${otherUser['name']}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Say hi...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Send'),
            ),
          ],
        );
      },
    );

    if (message != null && message.trim().isNotEmpty) {
      try {
        final Map<String, dynamic> myUser = Map<String, dynamic>.from(
          myProfile,
        );
        final Map<String, dynamic> updatedOtherUser = Map<String, dynamic>.from(
          _users[_currentIndex],
        );

        // Create match request
        await _apiService.createMatch(myUser['id'], updatedOtherUser['id']);

        // Fetch matches again
        final matches = await _apiService.getMatchesForUser(myUser['id']);

        final createdMatch = matches.firstWhere(
          (m) =>
              (m['user1']['id'] == myUser['id'] &&
                  m['user2']['id'] == updatedOtherUser['id']) ||
              (m['user2']['id'] == myUser['id'] &&
                  m['user1']['id'] == updatedOtherUser['id']),
          orElse: () => null,
        );

        if (createdMatch == null) {
          debugPrint('No match found after creating one.');
          return;
        }

        // Send the message
        await _apiService.sendMessage({
          'matchId': createdMatch['id'],
          'senderId': myUser['id'],
          'content': message,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Request and message sent to ${updatedOtherUser['name']}!',
            ),
          ),
        );
      } catch (e) {
        debugPrint('Swipe right error: $e');
      }
    }

    _currentIndex++;
    notifyListeners();
  }

  void swipeBack() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void _moveNext() {
    if (_currentIndex < _users.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      _currentIndex = _users.length;
      notifyListeners();
    }
  }
}
