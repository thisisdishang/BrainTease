import 'package:html_unescape/html_unescape.dart';

class QuestionModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer']);
    allOptions.shuffle(); // Randomize options

    return QuestionModel(
      question: unescape.convert(json['question']),  // Decode question text
      options: allOptions.map((e) => unescape.convert(e)).toList(), // Decode options
      correctAnswer: unescape.convert(json['correct_answer']), // Decode correct answer
    );
  }
}
