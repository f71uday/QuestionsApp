import 'package:flutter/material.dart';


class NoInternetPage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<NoInternetPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
           Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Image.asset('assets/no-internet.png'),
        ),
      ),
    );
  }
}