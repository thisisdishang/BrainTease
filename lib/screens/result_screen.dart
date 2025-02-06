import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, String>> questions; // Add questions field

  const ResultScreen(
      {super.key,
      required this.score,
      required this.totalQuestions,
      required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "Quiz Result",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Your Score: $score/$totalQuestions",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text("Q: ${question['question']}"),
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
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/main', (route) => false);
              },
              child: const Text("Back to Home"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
