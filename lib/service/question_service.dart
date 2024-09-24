import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/models/feedback/feedback.dart';
import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/Questions/question.dart';
import '../models/paged_response.dart';
import '../models/test_result.dart';
import 'authorized_client.dart';
import 'fault_navigator.dart';

class QuestionService extends FaultNavigator {
  QuestionService(super.context);

  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? bookmarkPath = dotenv.env['BOOKMARK'];
  final String? getBookmarkUrl = dotenv.env['BOOKMARKED_QUESTIONS'];
  final String? feedbackLink = dotenv.env['FEEDBACK_URL'];
  var http_response;

  Future<List<Question>> fetchQuestions(String? subjectIds, String path) async {
    final response = await _httpService.authorizedGET(
        '$baseUrl$path', {'subjectIds': subjectIds, 'projection': 'app'});

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

  Future<List<QuestionResponses>> getBookMarked({required int page}) async {
    String path = baseUrl! + getBookmarkUrl!;
    final response = await HttpService().authorizedGET(path, {'page': page});
    log('fetch subject response : $response.body');
    _handleError(response);

    PagedResponse pagedResponse = PagedResponse.fromJson(response.data);
    log('subjects loaded successfully. subjects: $response.data');
    return pagedResponse.embedded!.bookmarkedQuestions!;
  }

  void submitFeedBack(UserFeedback feedback) async {
    String path = baseUrl! + feedbackLink!;
    String body = jsonEncode(feedback.toJson());
    log('sending flag : $body');
    final response = await HttpService()
        .authorizedPOST(path, {}, jsonEncode(feedback.toJson()));
    log('flag response : ${response.data.toString()}');
    _handleError(response);

  }

  void _handleError(Response response) {
    if (response.statusCode != 200 && response.statusCode != 401 && response.statusCode != 201) {
      log("Could not send flag response : ${response.statusCode} and response body: ${response.data}");

      //TODO:Handle to show No Internet Screen
      throw Exception('An error occurred while connecting to server');
    } else if (response.statusCode == 401) {
      navigateToLoginScreen();
    }
  }
}
