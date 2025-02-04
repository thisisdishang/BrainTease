import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_history_model.dart';
import '../providers/quiz_history_provider.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String difficulty;

  const QuizScreen(
      {super.key, required this.categoryId, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuestionModel>> _quizFuture;
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;
  final List<Map<String, String>> _quizQuestions = [];

  // Mapping category ID to category name
  static const Map<int, String> categoryMap = {
    9: "General Knowledge",
    10: "Books",
    11: "Film",
    12: "Music",
    15: "Video Games",
    18: "Computers",
    19: "Mathematics",
    21: "Sports",
    23: "History",
    26: "Celebrity",
    27: "Animals",
    28: "Vehicles",
    30: "Gadgets",
  };

  @override
  void initState() {
    super.initState();
    _quizFuture =
        ApiService().fetchQuestions(widget.categoryId, widget.difficulty);
  }

  void _checkAnswer(String answer, String correctAnswer, dynamic snapshot) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == correctAnswer) _score++;
    });

    // Save question and answer to history
    _quizQuestions.add({
      "question": snapshot.data![_currentIndex].question, // FIXED
      "selectedAnswer": answer,
      "correctAnswer": correctAnswer,
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < 9) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _selectedAnswer = null;
        });
      } else {
        // Store Quiz History after completion
        Provider.of<QuizHistoryProvider>(context, listen: false).addHistory(
          QuizHistoryModel(
            category: widget.categoryId.toString(),
            difficulty: widget.difficulty,
            score: _score,
            totalQuestions: 10,
            questions: _quizQuestions,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: _score, totalQuestions: 10),
          ),
        );
      }
    });
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you don\'t want to play this quiz?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue.shade900,
          title: Text(
            "${categoryMap[widget.categoryId] ?? "Unknown Category"} - ${widget.difficulty[0].toUpperCase() + widget.difficulty.substring(1)}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<QuestionModel>>(
          future: _quizFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(child: Text("Failed to load questions."));
            }

            QuestionModel question = snapshot.data![_currentIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Question ${_currentIndex + 1}/10",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(question.question,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ...question.options.map((option) => GestureDetector(
                        onTap: () => _checkAnswer(
                            option, question.correctAnswer, snapshot),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _answered
                                ? (option == question.correctAnswer
                                    ? Colors.green
                                    : (option == _selectedAnswer
                                        ? Colors.red
                                        : Colors.grey[300]))
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(option,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center),
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
