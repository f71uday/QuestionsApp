import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/Questions/question.dart';
import '../models/test_result.dart';
import 'authorized_client.dart';
import 'fault_navigator.dart';

class QuestionService extends FaultNavigator {
  QuestionService(super.context);

  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? subjectTest = dotenv.env['SUBJECT_TEST'];
  final String? bookmarkPath = dotenv.env['BOOKMARK'];
  var http_response;

  Future<List<Question>> fetchQuestions(String subjectIds) async {
    final response = await _httpService.authorizedGET('$baseUrl$subjectTest',
        {'subjectIds': subjectIds, 'projection': 'app'});

    if (response.statusCode == 200) {
      http_response = response;
      final questionsJson = response.data['questions'] as List;
      try {
        return questionsJson.map((json) => Question.fromJson(json)).toList();
      } catch (error) {
        log("error while parsing Response");
      }
    } else if (response.statusCode == 401) {
      log(" question service returned $response.statusCode with body$response.body.toString() ");
      navigateToLoginScreen();
    }
    //Global error page
    return [];
  }

  String getResponseLink() {
    return http_response.data['_links']['response']['href'] as String;
  }

  String getQuizName() {
    return http_response.data['name'];
  }

  String getQuizDesc() {
    return http_response.data['description'];
  }

  Future<TestResult?> fetchTestResponse(
    String link,
    String jsonBody,
  ) async {
    final response =
        await HttpService().authorizedPost(Uri.parse(link), jsonBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return TestResult.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      navigateToLoginScreen();
    }
    //Global error page

    return null;
  }

  createBookmark(int id) async {
    String path =
        baseUrl! + bookmarkPath!.replaceFirst('{questionId}', id.toString());
    final response = await HttpService().authorizedPOST(path, {}, null);
    log(response.statusCode.toString());
  }

  deleteBookMark(int id) async {
    String path =
        baseUrl! + bookmarkPath!.replaceFirst('{questionId}', id.toString());
    final response = await HttpService().authorizedDELETE(path, {});
    log(response.statusCode.toString());

  }
}
