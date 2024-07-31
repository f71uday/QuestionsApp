import 'dart:convert';
import 'package:VetScholar/models/intialize_login_flow/InitializeLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String baseURL = '127.0.0.1:4433';
  bool _isLoginSuccessful = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        final url = Uri.http(baseURL, '/self-service/login/api', {'refresh': 'false'});
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final httpResponse = json.decode(response.body);
          final intializeLogin = IntializeLoginFlow.fromJson(httpResponse);
          final loginResponse = await http.post(
            Uri.parse(intializeLogin.ui.action),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {
              'identifier': _usernameController.text,
              'password': _passwordController.text,
              'method': 'password',
            },
          );
          if (loginResponse.statusCode == 200) {
            final loginData = json.decode(loginResponse.body);
            final loginResponseObject = LoginResponse.fromJson(loginData);

            // Save session token in secure storage
            await secureStorage.write(key: 'session_token', value: loginResponseObject.sessionToken);
            await secureStorage.write(key: 'name', value :loginResponseObject.session?.identity?.traits?.name?.first);
            await secureStorage.write(key: 'email', value :loginResponseObject.session?.identity?.traits?.email);
            setState(() {
              _isLoginSuccessful = true;
              _showCustomToast();
              Navigator.pushReplacementNamed(context, '/subjects');
            });
          } else {
            setState(() {
              _isLoginSuccessful = false;
              _errorMessage = 'Incorrect Username or Password';
              _showErrorMessage(_errorMessage);
            });
          }
        } else {
          setState(() {
            _isLoginSuccessful = false;
            _errorMessage = 'Server error. Please try again later.';
            _showErrorMessage(_errorMessage);
          });
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Network error. Please check your connection.';
          _isLoginSuccessful = false;
          _showErrorMessage(_errorMessage);
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: Text(message)),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showCustomToast() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Text("Logged in Successfully"),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Spacer(),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: 'Username', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password', border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => {
                                Navigator.pushReplacementNamed(context, '/subjects')
                              },
                              child: Text('Forgot Password?')
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Spacer(),
            Column(
              children: [
                if (!_isLoading)
                  SizedBox(
                    width: double.infinity, // Make the button take the full width
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                  ),
                if (_isLoading)
                  LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account?"),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushReplacementNamed(context, '/subjects')
                      },
                      child: Text('SignUp'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}