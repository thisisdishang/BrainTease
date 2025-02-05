import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_history_model.dart';

class QuizHistoryProvider with ChangeNotifier {
  List<QuizHistoryModel> _history = [];

  List<QuizHistoryModel> get history => _history;

  QuizHistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyString = prefs.getString('quiz_history');
    if (historyString != null) {
      final List<dynamic> historyJson = jsonDecode(historyString);
      _history = historyJson.map((json) => QuizHistoryModel.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> addHistory(QuizHistoryModel quizHistory) async {
    final existingHistoryIndex = _history.indexWhere((history) =>
        history.category == quizHistory.category &&
        history.difficulty == quizHistory.difficulty);

    if (existingHistoryIndex != -1) {
      // Append new results to existing history
      _history[existingHistoryIndex].questions.addAll(quizHistory.questions);
      _history[existingHistoryIndex].score += quizHistory.score;
      _history[existingHistoryIndex].totalQuestions += quizHistory.questions.length; // Corrected setter
    } else {
      // Add new history entry
      _history.add(quizHistory);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_history', jsonEncode(_history.map((quiz) => quiz.toMap()).toList()));
    notifyListeners();
  }
}
