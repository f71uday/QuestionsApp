import 'dart:convert';
import 'dart:developer';

import 'package:VetScholar/models/subjects.dart';
import 'package:VetScholar/service/authorized_client.dart';

class SubjectService {
  final HttpService _httpService = HttpService();
  final Uri resourceBasePath = Uri.parse('http://127.0.0.1/api/subjects');

  Future<List<Subject>> fetchSubjects() async {
    log('Request to fetch subject initialized.');
    final response = await _httpService.authorizedGet(resourceBasePath);

    log('fetch subject response : $response');

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      final subjectsJson = parsed['_embedded']['subjects'] as List;

      log('subjects loaded successfully. subjects: $subjectsJson');
      return subjectsJson.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}
