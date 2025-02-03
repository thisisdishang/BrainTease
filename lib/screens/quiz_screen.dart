import 'package:flutter/material.dart';
import 'dart:async';
import '../models/question_model.dart';
import 'result_screen.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_history_provider.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const QuizScreen(
      {super.key, required this.category, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuestionModel> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions(); // Fetch or generate questions
  }

  List<QuestionModel> _generateQuestions() {
    return [
      QuestionModel(
          question: "What is 2 + 2?",
          options: ["3", "4", "5"],
          correctAnswer: "4"),
      QuestionModel(
          question: "Which planet is known as the Red Planet?",
          options: ["Earth", "Mars", "Jupiter"],
          correctAnswer: "Mars"),
      QuestionModel(
          question: "What is the capital of France?",
          options: ["Berlin", "Madrid", "Paris"],
          correctAnswer: "Paris"),
    ];
  }

  void _checkAnswer(String answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == _questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswer = null;
        });
      } else {
        _saveResult();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: _score, totalQuestions: _questions.length),
          ),
        );
      }
    });
  }

  void _saveResult() {
    String result =
        "${widget.category} - ${widget.difficulty}: $_score/${_questions.length}";
    Provider.of<QuizHistoryProvider>(context, listen: false).addHistory(result);
  }

  @override
  Widget build(BuildContext context) {
    QuestionModel currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent.shade400,
          title: Text(
            "${widget.category} - ${widget.difficulty}",
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question ${_currentQuestionIndex + 1}/${_questions.length}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.map((option) => GestureDetector(
                  onTap: () => _checkAnswer(option),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _answered
                          ? (option == currentQuestion.correctAnswer
                              ? Colors.green
                              : (option == _selectedAnswer
                                  ? Colors.red
                                  : Colors.grey[300]))
                          : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
