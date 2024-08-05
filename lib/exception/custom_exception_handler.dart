import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  ErrorPage({this.errorMessage = 'Something went wrong. Please try again.'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://your-dog-image-url.com/dog.jpg', // Replace with your dog image URL
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to the previous screen
                },
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}