import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _profile;

  Map<String, dynamic>? get profile => _profile;

  void setProfile(Map<String, dynamic> profile) {
    _profile = profile;
    _saveProfileToPrefs();
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    _removeProfileFromPrefs();
    notifyListeners();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_profile');
    if (jsonString != null) {
      _profile = jsonDecode(jsonString);
      notifyListeners();
    }
  }

  Future<void> _saveProfileToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_profile != null) {
      prefs.setString('user_profile', jsonEncode(_profile));
    }
  }

  Future<void> _removeProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_profile');
  }
}
