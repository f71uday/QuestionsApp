import 'dart:convert';

import 'package:VetScholar/models/intialize_login_flow/InitializeLogin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FToast fToast;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String baseURL = '127.0.0.1:4433';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try{
        final url = Uri.http(  baseURL, '/self-service/login/api', {
          'refresh': 'false'
        });
        final  response = await http.get(url);
        if (response.statusCode == 200) {
          final httpResponse = json.decode(response.body);
            final intializeLogin = IntializeLoginFlow.fromJson(httpResponse);
          final loginResponse = await http.post(
            Uri.parse(intializeLogin.ui.action ),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body:  {
              'identifier': _usernameController.text,
              'password': _passwordController.text,
              'method': 'password',
            }
          );
          if (loginResponse.statusCode == 200){
            setState(() {
              _showCustomToast();
              Navigator.pushReplacementNamed(context, '/subjects');
            });
          }
          }
        } catch (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.toString();
        });
      } finally {
        _isLoading = false;
      }
    }
  }


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_isLoading) CircularProgressIndicator(),
              if (_errorMessage.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(onPressed: () => {
              Navigator.pushReplacementNamed(context, '/subjects')
              }, child: Text('Skip Sign In'))
            ],
          ),
        ),
      ),
    );
  }
}