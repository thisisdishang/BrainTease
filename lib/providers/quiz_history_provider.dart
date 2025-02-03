import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_history_model.dart';

class QuizHistoryProvider extends ChangeNotifier {
  List<QuizHistoryModel> _history = [];

  List<QuizHistoryModel> get history => _history;

  QuizHistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getString('quiz_history');

    if (historyData != null) {
      _history = (jsonDecode(historyData) as List)
          .map((e) => QuizHistoryModel.fromJson(e))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addQuizToHistory(QuizHistoryModel quizResult) async {
    _history.insert(0, quizResult); // Add new result at the top
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final historyData = jsonEncode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('quiz_history', historyData);
  }
}
