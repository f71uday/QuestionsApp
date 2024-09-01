import 'dart:convert';
import 'dart:developer';
import 'package:VetScholar/models/intialize_login_flow/InitializeLogin.dart';
import 'package:VetScholar/ui/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  String? baseURL = (dotenv.env['BASE_URL'])?.trim();
  String? initializeSignIn = dotenv.env['INITIALIZE_LOGIN'];
  String? sessionTokenKey = dotenv.env['SESSION_TOKEN_KEY'];
  bool _isLoginSuccessful = false;
  bool _obscureText = true;

  @override
  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        final url = Uri.parse(baseURL!).resolve(initializeSignIn!);
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

          log(loginResponse.toString());

          if (loginResponse.statusCode == 200) {
            final loginData = jsonDecode(loginResponse.body);

            // Save session token in secure storage SESSION_TOKEN_KEY
            await secureStorage.write(
                key: sessionTokenKey!, value: loginData[sessionTokenKey!]);

            setState(() {
              _isLoginSuccessful = true;
              _showCustomToast();
              Navigator.pushReplacementNamed(
                  context, dotenv.env['ROUTE_SUBJECTS']!);
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
    CustomSnackBar().showCustomToastWithCloseButton(
        context, Colors.red, Icons.close, message);
  }

  void _showCustomToast() {
    CustomSnackBar().showCustomToast(
        context, Colors.green, Icons.check, "LoggedIn Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      Flexible(
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/forgot-password'),
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Column(
              children: [
                if (!_isLoading)
                  SizedBox(
                    width: double.infinity,
                    // Make the button take the full width
                    child: FilledButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                  ),
                if (_isLoading) const LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an Account?"),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, dotenv.env['ROUTE_SIGNUP']!),
                      child: const Text('SignUp'),
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
