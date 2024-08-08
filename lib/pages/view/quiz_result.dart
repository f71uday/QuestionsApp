import 'package:flutter/material.dart';

class ColorAnimationPage extends StatefulWidget {
  final bool isRed; // Determines whether the color is red or green
  final double percentage;
  ColorAnimationPage({
    required this.isRed,
    required this.percentage

  });

  @override
  _ColorAnimationPageState createState() => _ColorAnimationPageState();
}

class _ColorAnimationPageState extends State<ColorAnimationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isRed ? Icons.thumb_up : Icons.thumb_down,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.isRed
                        ? 'Congratulations! You passed!'
                        : 'Better luck next time!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    //'Your score: $score / $totalQuestions\n(${percentage.toStringAsFixed(2)}%)',
                    'Your score ${widget.percentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Go back to the previous screen
                    },
                    child: Text('Back to Home'),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.white, // Background color
                    //   onPrimary: isPassed ? Colors.green : Colors.red, // Text color
                    // ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.red, Colors.red.withOpacity(0.0)],
                  stops: [_animation.value, _animation.value],
                  radius: 1.0,

                ),
              ),
            );
          },
        ),
      ),
    );
  }
}