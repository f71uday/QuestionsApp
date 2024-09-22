import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:VetScholar/service/context_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pages/quiz_page.dart';

class AppLinkServices {
  static String testCode = '';

  static String get getCode => testCode;

  static bool get hasCode => testCode.isNotEmpty;

  static void reset() => testCode = '';


  static AppLinks? _appLinkInstance;

  static Future<void> init() async {
    try {
      _appLinkInstance = AppLinks();

      final Uri? initialUri = await _appLinkInstance!.getInitialLink();
      if (initialUri != null) {
        appLinkHandler(initialUri);
      }
      _appLinkInstance!.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          appLinkHandler(uri);
        }
      }, onError: (error) {
        log('Error in URI Link Stream: $error');
      });
    } catch (e) {
      log("Unable to initialize app links for universal linking: $e");
    }
  }

  static void appLinkHandler(Uri uri) {
    if (uri.queryParameters.isEmpty) return;

    String receivedCode = uri.queryParameters['code'] ?? '';
    String? testUrl = dotenv.env['TESTWITHID'];
    testUrl = testUrl!.replaceFirst('{testId}', receivedCode);
    Navigator.push(
      ContextUtility.context!,
      MaterialPageRoute(
        builder: (context) => QuizPage(selectedSubjects: null,testLink: testUrl!),
      ),
    );
  }
}