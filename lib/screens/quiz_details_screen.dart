import 'package:flutter/material.dart';
import '../models/quiz_history_model.dart';

class QuizDetailsScreen extends StatelessWidget {
  final QuizHistoryModel quiz;
  final String categoryName;

  const QuizDetailsScreen(
      {super.key, required this.quiz, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Quiz Details - $categoryName",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: quiz.questions.length,
        itemBuilder: (context, index) {
          final question = quiz.questions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                "Q${index + 1}: ${question['question']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Answer: ${question['selectedAnswer']}",
                      style: TextStyle(
                          color: question['selectedAnswer'] ==
                                  question['correctAnswer']
                              ? Colors.green
                              : Colors.red)),
                  Text("Correct Answer: ${question['correctAnswer']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
