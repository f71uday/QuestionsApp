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
  void showCustomToastWithCloseButton(BuildContext context, Color color, IconData icons, String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icons,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}