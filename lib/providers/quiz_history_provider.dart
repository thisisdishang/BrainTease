import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizHistoryProvider extends ChangeNotifier {
  List<String> _history = [];

  List<String> get history => _history;

  QuizHistoryProvider() {
    _loadHistory();
  }

  void addHistory(String result) async {
    _history.add(result);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('quiz_history', _history);
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('quiz_history') ?? [];
    notifyListeners();
  }
}
