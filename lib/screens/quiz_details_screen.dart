import 'package:flutter/material.dart';
import '../models/quiz_history_model.dart';

class QuizDetailsScreen extends StatefulWidget {
  final QuizHistoryModel quiz;
  final String categoryName;

  const QuizDetailsScreen(
      {super.key, required this.quiz, required this.categoryName});

  @override
  _QuizDetailsScreenState createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (widget.quiz.questions.length / 10).ceil();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Quiz Details - ${widget.categoryName}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * 10;
                final endIndex =
                    (startIndex + 10).clamp(0, widget.quiz.questions.length);
                final questions =
                    widget.quiz.questions.sublist(startIndex, endIndex);

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
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
                            Text(
                                "Correct Answer: ${question['correctAnswer']}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _currentPage < totalPages - 1
                    ? () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
