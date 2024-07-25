
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz_page.dart';
import 'package:flutter_application_2/pages/subject_list_page.dart';
import 'package:flutter_application_2/pages/signin_page.dart';

void main() {
  runApp(QuizApp());
}


class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInPage(),
        '/quiz': (context) => QuizPage(),
        '/subjects': (context) => SubjectListPage()
      },
    );
  }
}

