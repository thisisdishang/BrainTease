class QuizHistoryModel {
  final String category;
  final String difficulty;
  final int score;
  final int totalQuestions;
  final List<Map<String, String>> questions; // Storing questions

  QuizHistoryModel({
    required this.category,
    required this.difficulty,
    required this.score,
    required this.totalQuestions,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'difficulty': difficulty,
        'score': score,
        'totalQuestions': totalQuestions,
        'questions': questions,
      };

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      category: json['category'],
      difficulty: json['difficulty'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      questions: List<Map<String, String>>.from(json['questions']),
    );
  }
}
