import 'package:flutter/material.dart';

class ColorAnimationPage extends StatefulWidget {
  final bool isRed; // Determines whether the color is red or green
  final double percentage;

  ColorAnimationPage({
    required this.isRed,
    required this.percentage,
  });

  @override
  _ColorAnimationPageState createState() => _ColorAnimationPageState();
}

class _ColorAnimationPageState extends State<ColorAnimationPage>
    with SingleTickerProviderStateMixin {
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
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2.0 * _animation.value, // Animate the radius to fill the screen
                colors: [
                  widget.isRed ? Colors.red : Colors.green,
                  Colors.transparent,
                ],
                stops: [_animation.value, _animation.value + 0.1],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isRed ? Icons.thumb_down : Icons.thumb_up,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  widget.isRed
                      ? 'Better luck next time!'
                      : 'Congratulations! You passed!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Your score: ${widget.percentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}