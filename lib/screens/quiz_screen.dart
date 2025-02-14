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
  List<QuestionModel> _quizQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;
  bool _isLoading = true;
  bool _hasError = false;
  final PageController _pageController = PageController();

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
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      _quizQuestions = await ApiService()
          .fetchQuestions(widget.categoryId, widget.difficulty);
      if (_quizQuestions.isEmpty) {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkAnswer(String answer, String correctAnswer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == correctAnswer) _score++;
    });

    // Save question and answer to history
    _quizQuestions[_currentIndex].selectedAnswer = answer;

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < 9) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _selectedAnswer = null;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
        );
      } else {
        // Store Quiz History after completion
        Provider.of<QuizHistoryProvider>(context, listen: false).addHistory(
          QuizHistoryModel(
            category: widget.categoryId.toString(),
            difficulty: widget.difficulty,
            score: _score,
            totalQuestions: 10,
            questions: _quizQuestions
                .map((q) => {
                      'question': q.question,
                      'correctAnswer': q.correctAnswer,
                      'selectedAnswer': q.selectedAnswer ?? '',
                      'options': q.options.join(','),
                    })
                .toList(),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
                score: _score,
                totalQuestions: 10,
                questions: _quizQuestions
                    .map((q) => {
                          'question': q.question,
                          'correctAnswer': q.correctAnswer,
                          'selectedAnswer': q.selectedAnswer ?? '',
                        })
                    .toList()),
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
          title: const Text('Quit Quiz'),
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
              child: const Text('Accept'),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / 10,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue.shade900,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height) / 4,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Question ${_currentIndex + 1}/10",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _hasError
                      ? const Center(child: Text("Failed to load questions."))
                      : PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            QuestionModel question = _quizQuestions[index];

                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      question.question,
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 3, // Adjusted aspect ratio
                                        ),
                                        itemCount: question.options.length,
                                        itemBuilder: (context, optionIndex) {
                                          final option =
                                              question.options[optionIndex];
                                          return GestureDetector(
                                            onTap: () => _checkAnswer(
                                                option, question.correctAnswer),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: _answered
                                                    ? (option ==
                                                            question
                                                                .correctAnswer
                                                        ? Colors.green
                                                        : (option ==
                                                                _selectedAnswer
                                                            ? Colors.red
                                                            : Colors.grey[300]))
                                                    : Colors.blue[100],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  option,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
