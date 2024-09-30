import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:VetScholar/service/context_utility.dart';
import 'package:VetScholar/ui/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../models/intialize_login_flow/InitializeLogin.dart';

class SignInService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String? _baseURL = (dotenv.env['BASE_URL'])?.trim();
  final String? _initializeSignIn = dotenv.env['INITIALIZE_LOGIN'];
  final dioService = dio.Dio();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? sessionTokenKey = dotenv.env['SESSION_TOKEN_KEY'];
  Future<dio.Response> initializeLogin() async {
    return await dioService.get(_baseURL! + _initializeSignIn!);
  }

  // Helper function to generate nonce
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join('');
  }

  // https://pub.dev/packages/flutter_appauth

  Future<void> handleSignIn() async {
    final intiResponse = await initializeLogin();
    final intData = IntializeLoginFlow.fromJson(intiResponse.data);
    final String nonce = generateNonce();
    try {
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            '1060248932526-u6tenjuuk7iqnis7ua64fm4h7uf37ebu.apps.googleusercontent.com',
            'com.googleusercontent.apps.1060248932526-u6tenjuuk7iqnis7ua64fm4h7uf37ebu:/oauth2redirect/google',
            issuer: 'https://accounts.google.com',
            scopes: ['openid', 'profile', 'email'],
            nonce: nonce),
      );

      dev.log(result.toString());
      if (intiResponse.statusCode!= 200){
        CustomSnackBar().showCustomToastWithCloseButton(ContextUtility.context!, Colors.red, Icons.close, 'Failed to login. Try Again');
        return;
      }
      // Send the ID token to Ory Kratos
      final response = await http.post(
        Uri.parse(intData.ui.action
            ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'method': 'oidc',
          'provider': 'google',
          'id_token': result.idToken,
          'id_token_nonce': nonce
        }),
      );

      final loginData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await secureStorage.write(
            key: sessionTokenKey!, value: loginData[sessionTokenKey!]);
        Navigator.pushReplacementNamed(
            ContextUtility.context!, dotenv.env['ROUTE_SUBJECTS']!);
      } else {
        // Handle error
        dev.log("Failed to log in: ${response.body}");
        CustomSnackBar().showCustomToastWithCloseButton(ContextUtility.context!, Colors.red, Icons.close, 'Failed to Login');
      }
    } on FlutterAppAuthUserCancelledException catch (e) {
      dev.log('User cancelled google oauth: $e');
      CustomSnackBar().showCustomToastWithCloseButton(ContextUtility.context!, Colors.red, Icons.close, 'Failed to Login');
    } catch (error) {
      dev.log('Error signing in: $error');
      CustomSnackBar().showCustomToastWithCloseButton(ContextUtility.context!, Colors.red, Icons.close, 'Failed to Login');
    }
  }
}
