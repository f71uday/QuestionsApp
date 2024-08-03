import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String> getAccessToken() async {
    log('get access token called.');

    final token = await _storage.read(key: 'session_token');
    if (token == null) {
      // TODO: redirect to login screen if no token found or is expired.
      throw Exception('No access token found');
    }

    log('get access token found, value : $token');
    return token;
  }
}
