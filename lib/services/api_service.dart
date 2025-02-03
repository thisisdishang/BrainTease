import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class ApiService {
  Future<List<QuestionModel>> fetchQuestions(int categoryId, String difficulty) async {
    final url = "https://opentdb.com/api.php?amount=10&category=$categoryId&difficulty=$difficulty&type=multiple";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List).map((q) => QuestionModel.fromJson(q)).toList();
    } else {
      throw Exception("Failed to load questions");
    }
  }
}
