import 'package:braintease/screens/main_screen.dart';
import 'package:braintease/screens/quiz_screen.dart';
import 'package:braintease/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/quiz_history_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizHistoryProvider(),
      child: const QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainTease',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainScreen(),
        '/quiz': (context) => QuizScreen(
              categoryId: (ModalRoute.of(context)!.settings.arguments
                  as Map)['categoryId'],
              difficulty: (ModalRoute.of(context)!.settings.arguments
                  as Map)['difficulty'],
            ),
        '/result': (context) => ResultScreen(
              score:
                  (ModalRoute.of(context)!.settings.arguments as Map)['score'],
              totalQuestions: (ModalRoute.of(context)!.settings.arguments
                  as Map)['totalQuestions'],
            ),
      },
    );
  }
}
