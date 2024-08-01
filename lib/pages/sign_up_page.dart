// signup_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String baseURL = '127.0.0.1:4433';
  bool _acceptTerms = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Start the registration flow to get the CSRF token and flow ID
        final initResponse = await http.get(
          Uri.http(baseURL, '/self-service/registration/api'),
        );
        if (initResponse.statusCode != 200) {
          _showSnackBar('Failed to initialize registration. Please try again.', false);
          return;
        }

        final initJson = jsonDecode(initResponse.body);
        final flowId = initJson['id'];
        //final csrfToken = initJson['csrf_token'];

        final response = await http.post(
          Uri.http(baseURL, '/self-service/registration', {'flow': flowId}),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'traits.email': _emailController.text,
            'traits.name.first': _firstNameController.text,
            'traits.name.last': _lastNameController.text,
            //'csrf_token': csrfToken,
            'method': 'password',
            'password': _passwordController.text,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          _showSnackBar('Signup successful!', true);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/signin');
          });
        } else {
          final errorResponse = json.decode(response.body);
          _showSnackBar(errorResponse['ui']['messages'][0]['text'] ?? 'Signup failed. Please try again.', false);
        }
      } catch (error) {
        _showSnackBar('Network error. Please check your connection.', false);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check : Icons.error,
              color: Colors.white,
            ),
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
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),

                            ),
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Align(

            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text("I accept the terms and conditions", style: TextStyle(fontSize: 14),),
                      value: _acceptTerms,
                      onChanged: (newValue) {
                        setState(() {
                          _acceptTerms = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                      if(!_isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signup,
                          child: Text('Signup'),
                        ),
                      ),
                    if (_isLoading) LinearProgressIndicator(),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}