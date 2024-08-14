import 'package:flutter/material.dart';

class CustomSnackBar{

  void showCustomToast(BuildContext context, Color color, IconData icons, String text) {

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icons, color: Colors.white),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showCustomToastWithCloseButton(BuildContext context, Color color, IconData icons, String text, Function() onPress){

  }
}