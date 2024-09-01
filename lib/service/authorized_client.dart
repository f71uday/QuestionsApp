import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;

import 'auth_service.dart';

class HttpService {
  final dioService = dio.Dio();

  Future<Response> authorizedGet(Uri url) async {
    String? sessionToken = await AuthService.getAccessToken();
    return await get(
      url,
      headers: {
        'Authorization': 'Bearer $sessionToken',
      },
    );
  }

  Future<Response> authorizedPost(Uri url, String body) async {
    String? sessionToken = await AuthService.getAccessToken();

    // Combine the provided headers with the Authorization header
    final Map<String, String> combinedHeaders = {
      'Authorization': 'Bearer $sessionToken',
      'Content-Type': 'application/json'
    };

    return await post(
      url,
      headers: combinedHeaders,
      body: body,
    );
  }

  Future<Response> authorizedDelete(Uri url, String body) async {
    String? sessionToken = await AuthService.getAccessToken();

    // Combine the provided headers with the Authorization header
    final Map<String, String> combinedHeaders = {
      'Authorization': 'Bearer $sessionToken',
      'Content-Type': 'application/json'
    };

    return await delete(
      url,
      headers: combinedHeaders,
      body: body,
    );
  }

  Future<dio.Response> authorizedGET(
      String path, Map<String, dynamic> queryParams) async {
    String? sessionToken = await AuthService.getAccessToken();
    return await dioService.get(path,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            "Authorization": 'Bearer $sessionToken',
          },
        ));
  }
}
