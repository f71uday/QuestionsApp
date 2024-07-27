
import 'package:VetScholar/pages/auth_page.dart';
import 'package:VetScholar/pages/signin_page.dart';
import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:flutter/material.dart';

import 'auth/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userInfo = await AuthService.getUserInfo();
  runApp(QuizApp(isLoggedIn: userInfo != null));
  //runApp(QuizApp());
}


class QuizApp extends StatelessWidget {
  final bool isLoggedIn;

  QuizApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn? '/subjects':'/auth',
      routes: {
        '/signin': (context) => SignInPage(),
        '/subjects': (context) => SubjectListPage(),
        '/auth': (context) => AuthPage()
      },
    );
  }
}

