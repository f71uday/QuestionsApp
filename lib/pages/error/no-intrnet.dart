import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetPage({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please check your network settings and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}