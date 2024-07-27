import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _userInfo = 'Not Logged In';

  Future<void> _login() async {
    final userInfo = await AuthService.login();
    setState(() {
      //_userInfo = userInfo != null ? userInfo.toString() : 'Login Failed';
      if (userInfo!= null ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SubjectListPage()),

        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User Info: $_userInfo'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectListPage()),
                );
              },
              child: Text('Go to Quiz Home'),
            ),
          ],
        ),
      ),
    );
  }
}