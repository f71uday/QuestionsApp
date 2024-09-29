import 'dart:convert';
import 'dart:developer';
import 'package:VetScholar/models/intialize_login_flow/InitializeLogin.dart';
import 'package:VetScholar/service/sign_in_service.dart';
import 'package:VetScholar/service/logging_service.dart';
import 'package:VetScholar/ui/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
        final response = await SignInService().initializeLogin();
        if (response.statusCode == 200) {
          final intializeLogin = IntializeLoginFlow.fromJson(response.data);
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
          EventLogger.logSignInEvent();

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
            const SizedBox(
              height: 70,
            ),
            const Image(image: AssetImage('assets/app_logo.png')),
            //const Spacer(),
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
                            border: const OutlineInputBorder(),
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
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                              onPressed: _login,
                              child: !_isLoading ? const Text('Login'):const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.white, // Match this to the button's text color
                                ),
                              ),
                          )),
                      const SizedBox(height: 20,),
                      const Row(
                        children: [

                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text('OR'),

                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {
                          SignInService().handleSignIn();

                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 30.0,
                                width: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24, right: 8),
                                child: Text(
                                  'Continue with Google',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // TODO : GoogleSignInButton(flowID: String, Funxtion<KroatosLogin),



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
      ),
    );
  }
}
