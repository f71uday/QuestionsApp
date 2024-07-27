import 'package:VetScholar/pages/error/no-intrnet.dart';
import 'package:flutter/material.dart';

class CustomExceptionHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    // Log or report the error
    print('Flutter Error: ${details.exceptionAsString()}');

    // Show a custom error dialog
    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return NoInternetPage();
      },
    );
  }

  static void handleDartError(Object error, StackTrace stack) {
    // Log or report the error
    print('Dart Error: $error');

    // Show a custom error dialog
    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('An error occurred'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Global navigator key for accessing the context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();