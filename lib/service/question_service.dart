import 'dart:convert';

import '../Questions/Question.dart';
import 'authorized_client.dart';

class QuestionService {
  final HttpService _httpService = HttpService();

  Future<List<Question>> fetchQuestions(String questionLink) async {
    final response = await _httpService.authorizedGet(Uri.parse(questionLink));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final questionsJson = parsed['questions'] as List;
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
