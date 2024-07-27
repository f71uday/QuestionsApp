

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static final FlutterAppAuth appAuth = FlutterAppAuth();
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static const String clientId = 'c11e931e-3fe5-4eea-9d4a-2be10d697bc0.uacinfo.com';
  static const String redirectUrl = 'uacinfo.com.c11e931e-3fe5-4eea-9d4a-2be10d697bc0://oauth2redirect';
  static const String issuer = 'http://localhost:9000';
  static const List<String> scopes = ['openid', 'profile', 'offline_access'];

  static Future<Map<String, dynamic>?> login() async {
    try {
      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          scopes: scopes,
          //usePKCE: true,
        ),
      );

      if (result != null) {
        await saveAuthorizationTokens(result);
        return {
          'accessToken': result.accessToken,
          'refreshToken': result.refreshToken,
          'idToken': result.idToken,
          //'accessTokenExpirationDate': result.accessTokenExpirationDate,
        };
      }
    } catch (e) {
      print('Authorization Error: $e');
    }
    return null;
  }
  static Future<bool> logout() async {
    try {
      await secureStorage.delete(key: 'authTokens'); // Adjust according to your key
      //TODO: IMplement Logout
      print('Logged out successfully');
      return true;
    } catch (error) {
      print('Error logging out: $error');
    }
    return false;
  }
  static Future<void> saveAuthorizationTokens(AuthorizationTokenResponse authState) async {
    try {
      await secureStorage.write(key: 'refresh_token', value: authState.refreshToken);
      await secureStorage.write(key: 'access_token', value: authState.accessToken);
      await secureStorage.write(key: 'id_token', value: authState.idToken);
      await secureStorage.write(key: 'access_token_expiration_date', value: authState.accessTokenExpirationDateTime?.toIso8601String());
      print('Authorization tokens saved successfully');
    } catch (e) {
      print('Error saving authorization tokens: $e');
    }
  }

  static Future<void> saveTokenResponse(TokenResponse tokenResponse) async {
    try {
      await secureStorage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
      await secureStorage.write(key: 'access_token', value: tokenResponse.accessToken);
      await secureStorage.write(key: 'id_token', value: tokenResponse.idToken);
      await secureStorage.write(key: 'access_token_expiration_date', value: tokenResponse.accessTokenExpirationDateTime?.toIso8601String());
      print('Token response saved successfully');
    } catch (e) {
      print('Error saving token response: $e');
    }
  }

  static Future<Map<String, dynamic>?> getTokens() async {
    try {
      String? refreshToken = await secureStorage.read(key: 'refresh_token');
      String? accessToken = await secureStorage.read(key: 'access_token');
      String? idToken = await secureStorage.read(key: 'id_token');
      String? accessTokenExpirationDate = await secureStorage.read(key: 'access_token_expiration_date');

      if (accessToken != null && accessTokenExpirationDate != null) {
        final DateTime now = DateTime.now();
        final DateTime expirationDate = DateTime.parse(accessTokenExpirationDate);

        if (expirationDate.isBefore(now)) {
          print('Access token expired, refreshing...');
          final Map<String, dynamic>? refreshedTokens = await refreshTokens(refreshToken);
          return refreshedTokens;
        } else {
          print('Access token not expired');
          return {
            'accessToken': accessToken,
            'idToken': idToken,
            'refreshToken': refreshToken,
            'accessTokenExpirationDate': accessTokenExpirationDate,
          };
        }
      } else {
        print('No tokens stored');
      }
    } catch (e) {
      print('Error retrieving tokens: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> refreshTokens(String? refreshToken) async {
    if (refreshToken == null) return null;

    try {
      final TokenResponse? result = await appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          refreshToken: refreshToken,
          issuer: issuer,
          scopes: scopes,
         // usePKCE: true,
        ),
      );

      if (result != null) {
        await saveTokenResponse(result);
        return {
          'accessToken': result.accessToken,
          'refreshToken': result.refreshToken,
          'idToken': result.idToken,
          //'accessTokenExpirationDate': result.accessTokenExpirationDate,
        };
      }
    } catch (e) {
      print('Error refreshing tokens: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final tokens = await getTokens();
      if (tokens != null && tokens['idToken'] != null) {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(tokens['idToken']);
        return decodedToken;
      } else {
        print('No idToken found, forcing login');
        final Map<String, dynamic>? loginResult = await login();
        if (loginResult != null && loginResult['idToken'] != null) {
          return JwtDecoder.decode(loginResult['idToken']);
        }
      }
    } catch (e) {
      print('Error decoding idToken: $e');
    }
    return null;
  }
}