import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  // Helper function to generate nonce
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join('');
  }

  // https://pub.dev/packages/flutter_appauth
  FlutterAppAuth appAuth = FlutterAppAuth();
  String? baseURL = (dotenv.env['BASE_URL'])?.trim();

  Future<void> _handleSignIn() async {
    final String nonce = generateNonce();
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            '1060248932526-u6tenjuuk7iqnis7ua64fm4h7uf37ebu.apps.googleusercontent.com',
            'com.googleusercontent.apps.1060248932526-u6tenjuuk7iqnis7ua64fm4h7uf37ebu:/oauth2redirect/google',
            issuer: 'https://accounts.google.com',
            scopes: ['openid', 'profile', 'email'],
            nonce: nonce),
      );

      print(result);

      // Send the ID token to Ory Kratos
      final response = await http.post(
        Uri.parse(
            'https://api.uacinfo.com/idp/self-service/login?flow=7046485f-9a09-4176-8cb8-07d80af00912'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'method': 'oidc',
          'provider': 'google',
          'id_token': result.idToken,
          'id_token_nonce': nonce
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful login
        print("Successfully logged in");
      } else {
        // Handle error
        print("Failed to log in: ${response.body}");
      }
    } on FlutterAppAuthUserCancelledException catch (e) {
      print('User cancelled google oauth: $e');
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleSignIn();
      },
      child: const Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/google_logo.png"),
              height: 30.0,
              width: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 8),
              child: Text(
                'Login with Google',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
