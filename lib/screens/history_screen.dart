import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_history_provider.dart';
import '../models/quiz_history_model.dart';
import 'quiz_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  final bool showBackButton;

  const HistoryScreen({super.key, this.showBackButton = true});

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
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<QuizHistoryProvider>(context);
    final historyList = historyProvider.history;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        backgroundColor: Colors.blue.shade900,
        title: const Center(
          child: Text(
            "Quiz History",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: historyList.isEmpty
          ? const Center(child: Text("No quiz history available."))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final QuizHistoryModel quiz = historyList[index];
                String categoryName =
                    categoryMap[int.tryParse(quiz.category) ?? 0] ??
                        "Unknown Category";

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                        "$categoryName - ${quiz.difficulty[0].toUpperCase() + quiz.difficulty.substring(1)}"),
                    subtitle: Text("Score: ${quiz.score}/${quiz.totalQuestions}"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizDetailsScreen(
                          quiz: quiz,
                          categoryName: categoryName,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
