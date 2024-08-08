
import 'package:VetScholar/pages/auth_page.dart';
import 'package:VetScholar/pages/sign_up_page.dart';
import 'package:VetScholar/pages/signin_page.dart';
import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:flutter/material.dart';

import 'service/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final accesstoken = await AuthService.getAccessToken();
  runApp(QuizApp(isLoggedIn: accesstoken != null));
  //runApp(QuizApp());
}


class QuizApp extends StatelessWidget {
  final bool isLoggedIn;

  QuizApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn? '/subjects':'/auth',
      //initialRoute: '/signin',
      routes: {
        '/signin': (context) => LoginPage(),
        '/subjects': (context) => SubjectListPage(),
        '/auth': (context) => AuthPage(),
        '/singup': (context) => SignupPage()
      },
    );
  }
}

