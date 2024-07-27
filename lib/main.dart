
import 'package:VetScholar/pages/auth_page.dart';
import 'package:VetScholar/pages/signin_page.dart';
import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(QuizApp());
}


class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/auth',
      routes: {
        '/signin': (context) => SignInPage(),
        '/subjects': (context) => SubjectListPage(),
        '/auth': (context) => AuthPage()
      },
    );
  }
}

