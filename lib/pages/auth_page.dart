import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth/auth_service.dart';


class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late FToast fToast;
  String _userInfo = 'Not Logged In';

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.lightGreen,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Text("Logged in Successfully"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future<void> _login() async {
    final userInfo = await AuthService.login();
    setState(() {
      //_userInfo = userInfo != null ? userInfo.toString() : 'Login Failed';
      if (userInfo!= null ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SubjectListPage())
        );
        _showCustomToast();
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