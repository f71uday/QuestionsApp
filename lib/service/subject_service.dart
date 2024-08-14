import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/models/subjects.dart';
import 'package:VetScholar/service/authorized_client.dart';
import 'package:VetScholar/service/fault_navigator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubjectService extends FaultNavigator{
  final HttpService _httpService = HttpService();
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String? subjects = dotenv.env['SUBJECTS'];

  SubjectService(super.context);

  Future<List<Subject>> fetchSubjects() async {
    log('Request to fetch subject initialized.');
    final response = await _httpService.authorizedGet(Uri.parse('$baseUrl$subjects'));

    log('fetch subject response : $response');

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final subjectsJson = parsed['_embedded']['subjects'] as List;

      log('subjects loaded successfully. subjects: $subjectsJson');
      return subjectsJson.map((json) => Subject.fromJson(json)).toList();
    }
      int code = response.statusCode;
      String body = response.body;
      log("Could not fetch Subject response code : $code and response body: $body");
      navigateToLoginScreen();
      return [];
  }
}
