import 'dart:convert';
import 'dart:developer';

import '../models/Questions/Question.dart';
import '../models/Questions/TestResult.dart';
import 'authorized_client.dart';
import 'fault_navigator.dart';

class QuestionService extends FaultNavigator {
  QuestionService(super.context);
  final HttpService _httpService = HttpService();

  var http_response;

  Future<List<Question>> fetchQuestions(String questionLink) async {
    final response = await _httpService.authorizedGet(Uri.parse(questionLink));

    if (response.statusCode == 200) {
      http_response = response;
      final parsed = json.decode(response.body);
      final questionsJson = parsed['questions'] as List;
      return questionsJson.map((json) => Question.fromJson(json)).toList();
    } else if(response.statusCode == 401) {
      log(" question service returned $response.statusCode with body$response.body.toString() ");
      navigateToLoginScreen();

    }
    //Global error page
    return [];
  }


  String fetchResponseLink() {

    final parsed = json.decode(http_response.body);
    return parsed['_links']['response']['href'] as String;
  }

  Future<TestResult?> fetchTestResponse(
      String link,
      String jsonBody,
      ) async {
    final response = await HttpService().authorizedPost(Uri.parse(link), jsonBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return TestResult.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      navigateToLoginScreen();
    }
    //Global error page

    return null;
  }
}
