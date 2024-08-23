
import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/service/fault_navigator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/src/response.dart';

import 'authorized_client.dart';

class TestHistoryServices extends FaultNavigator{
  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? subjects = dotenv.env['TEST_HISTORY'];

  TestHistoryServices(super.context);

  Future<Response> fetchHistory() async {

    log('Request to fetch test history initialized.');
    final response = await _httpService.authorizedGet(Uri.parse('$baseUrl$subjects'));

    log('fetch subject response : $response');
    if (response.statusCode!= 200 && response.statusCode !=401) {
      log("Could not fetch test history response code : $response.statusCode and response body: $response.body");
      throw Exception('An error occurred while connecting to server');
    }
    else if (response.statusCode == 401) {
      navigateToLoginScreen();
    }
      final parsed = json.decode(response.body);


      log('subjects loaded successfully. subjects: $parsed');
      return response;
    }

    }

