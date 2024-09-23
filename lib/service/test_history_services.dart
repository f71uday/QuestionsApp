import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/service/fault_navigator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/paged_response.dart';
import '../models/test_result.dart';
import 'authorized_client.dart';

class TestHistoryServices extends FaultNavigator {
  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? subjects = dotenv.env['TEST_HISTORY'];

  TestHistoryServices(super.context);

  Future<List<TestResult>?> fetchHistory({required int page}) async {
    log('Request to fetch test history initialized.');
    final response = await _httpService
        .authorizedGET('$baseUrl$subjects', {'size': 6, 'page': page});
    log('fetch subject response : $response.body');
    _handleError(response);

    PagedResponse pagedResponse = PagedResponse.fromJson(response.data);
    log('subjects loaded successfully. subjects: $response.data');
    return pagedResponse.embedded!.testResponses;
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

  Future<PagedResponse?> fetchTestQuestions(String uri) async {
    log('Request to fetch test Questions initialized.');
    final response = await _httpService
        .authorizedGET(uri, {'projection': 'app:history:detail'});
    if (response.statusCode != 200 && response.statusCode != 401) {
      //TODO:Handle to show No Internet Screen
      throw Exception('An error occurred while connecting to server');
    } else if (response.statusCode == 401) {
      navigateToLoginScreen();
    } else {
      try {
        PagedResponse pagedResponse = PagedResponse.fromJson(response.data);
        log('Questions loaded successfully. subjects: $response.data');
        return pagedResponse;
      }catch(e){
        log(e.toString());
      }
    }
    return null;
  }
}
