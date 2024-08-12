import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String> getAccessToken() async {
    log('get access token called.');
    String sessionTokenString = dotenv.env['SESSION_TOKEN_KEY'] ?? '';
    final token = await _storage.read(key: sessionTokenString);
    if (token == null) {
      // TODO: redirect to login screen if no token found or is expired.
      throw Exception('No access token found');
    }

    log('get access token found, value : $token');
    return token;
  }
}
