import 'dart:developer';

import 'package:VetScholar/service/fault_navigator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'authorized_client.dart';

class ProfileService {
  final HttpService _httpService = HttpService();



  Future<bool> whoami() async {
    String? baseUrl = dotenv.env['BASE_URL'];
    String? whoamiPath = dotenv.env['WHO_AM_I_PATH'];
    final response = await _httpService.authorizedGet(Uri.parse('$baseUrl$whoamiPath'));
    if (response.statusCode != 200 ){
      log("user have invalid session_id");
      return false;
    }
    log("user have valid session_id");
    return true;
  }

}