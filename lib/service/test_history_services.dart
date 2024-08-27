import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/service/fault_navigator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/paged_response.dart';
import '../models/test_result.dart';
import 'authorized_client.dart';
import 'package:http/src/response.dart';

class TestHistoryServices extends FaultNavigator {
  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? subjects = dotenv.env['TEST_HISTORY'];

  TestHistoryServices(super.context);

  Future<List<TestResult>?> fetchHistory() async {
    log('Request to fetch test history initialized.');
    final response =
        await _httpService.authorizedGet(Uri.parse('$baseUrl$subjects'));
    log('fetch subject response : $response');
    _handleError(response);
    final parsed = json.decode(response.body);
    PagedResponse pagedResponse = PagedResponse.fromJson(parsed);
    log('subjects loaded successfully. subjects: $parsed');
    return pagedResponse.embedded.testResponses;
  }

  void _handleError(Response response) {
     if (response.statusCode != 200 && response.statusCode != 401) {
      log("Could not fetch test history response code : $response.statusCode and response body: $response.body");

      //TODO:Handle to show No Internet Screen
      throw Exception('An error occurred while connecting to server');
    } else if (response.statusCode == 401) {
      navigateToLoginScreen();
    }
  }

  Future<List<QuestionResponses>?> fetchTestQuestions(Uri uri)
  async {
    log('Request to fetch test Questions initialized.');
    final response = await _httpService.authorizedGet(uri);
    _handleError(response);
    final parsed = json.decode(response.body);
    PagedResponse pagedResponse = PagedResponse.fromJson(parsed);
    log('subjects loaded successfully. subjects: $parsed');
    return pagedResponse.embedded.questionResponses;

  }
}
