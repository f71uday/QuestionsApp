import 'package:flutter/material.dart';
import '../pages/signin_page.dart';

class FaultNavigator {
  final BuildContext context;

  FaultNavigator(this.context);

  void navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}