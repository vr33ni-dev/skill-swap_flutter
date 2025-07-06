import 'package:flutter/material.dart';

class MatchProvider extends ChangeNotifier {
  List<dynamic> _matches = [];

  List<dynamic> get matches => _matches;

  void setMatches(List<dynamic> matches) {
    _matches = matches;
    notifyListeners();
  }
}
