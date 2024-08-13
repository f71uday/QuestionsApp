import 'dart:convert';
import 'dart:developer';


import 'package:VetScholar/pages/signin_page.dart';
import 'package:flutter/material.dart';

import '../models/Questions/Question.dart';
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
    } else {
      log(" question service returned $response.statusCode with body$response.body.toString() ");
      navigateToLoginScreen();

    }
    return [];
  }

  String fetchResponseLink() {

    final parsed = json.decode(http_response.body);
    return parsed['_links']['response']['href'] as String;
  }


}
