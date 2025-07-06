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
  Map<String, dynamic> myProfile = {}; // ✅ holds my skills

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

  Future<void> loadUsers(
    String myId,
    Map<String, dynamic> myProfileData,
  ) async {
    try {
      myUserId = myId;
      myProfile = myProfileData;

      final allUsers = await _apiService.getAllUsers();
      _allFetchedUsers = allUsers;

      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading users for swipe: $e');
    }
  }

  void swipeLeft() {
    _moveNext();
  }

  void swipeRight() {
    _moveNext();
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
