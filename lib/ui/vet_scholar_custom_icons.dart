import 'package:flutter/material.dart';

class VetScholarCustomIcons {
  static Widget bookmarkedAnswer(bool isCorrect) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Heart icon in the background
        Icon(
          Icons.circle,
          color: isCorrect ? Colors.green : Colors.red,
          size: 30,
        ),
        // Check icon in the foreground
        Icon(
          isCorrect ? Icons.check : Icons.close,
          color:Colors.white,
          size: 15,
        ),
      ],
    );
  }
}
