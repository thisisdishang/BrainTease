import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_history_model.dart';

class QuizHistoryProvider extends ChangeNotifier {
  List<QuizHistoryModel> _history = [];

  List<QuizHistoryModel> get history => _history;

  QuizHistoryProvider() {
    _loadHistory();
  }

  // Load history from SharedPreferences
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedHistory = prefs.getString('quiz_history');

    if (storedHistory != null) {
      List<dynamic> decoded = json.decode(storedHistory);
      _history = decoded.map((item) => QuizHistoryModel.fromJson(item)).toList();
      notifyListeners();
    }
  }

  // Add or replace quiz history
  Future<void> addHistory(QuizHistoryModel newQuiz) async {
    final existingIndex = _history.indexWhere((quiz) =>
        quiz.category == newQuiz.category &&
        quiz.difficulty == newQuiz.difficulty);

    if (existingIndex != -1) {
      // Replace existing entry
      _history[existingIndex] = newQuiz;
    } else {
      // Add new entry
      _history.add(newQuiz);
    }

    await _saveHistory();
    notifyListeners();
  }

  // Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_history.map((quiz) => quiz.toJson()).toList());
    await prefs.setString('quiz_history', encodedData);
  }
}
