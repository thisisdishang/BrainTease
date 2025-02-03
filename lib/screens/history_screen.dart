import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade400,
        title: Center(
          child: const Text(
            'Quiz History',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Consumer<QuizHistoryProvider>(
        builder: (context, historyProvider, child) {
          return historyProvider.history.isEmpty
              ? const Center(child: Text("No quiz history available."))
              : ListView.builder(
                  itemCount: historyProvider.history.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(historyProvider.history[index]),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
