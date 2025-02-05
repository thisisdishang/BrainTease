import 'dart:convert';

class QuizHistoryModel {
  final int? id;
  final String category;
  final String difficulty;
  int score;
  int totalQuestions; // Make totalQuestions mutable
  final List<Map<String, String>> questions;

  QuizHistoryModel({
    this.id,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.totalQuestions,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'difficulty': difficulty,
      'score': score,
      'totalQuestions': totalQuestions,
      'questions': jsonEncode(questions),
    };
  }

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      id: json['id'],
      category: json['category'],
      difficulty: json['difficulty'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      questions: List<Map<String, String>>.from(jsonDecode(json['questions']).map((item) => Map<String, String>.from(item))),
    );
  }
}
