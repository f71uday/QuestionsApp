import 'dart:convert';

import 'package:VetScholar/models/Remark.dart';
import 'package:VetScholar/models/test_result.dart';
import 'package:VetScholar/pages/error/no-intrnet.dart';
import 'package:VetScholar/pages/subject_list_page.dart';
import 'package:VetScholar/service/question_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/Questions/QuestionResponse.dart';

class ColorAnimationPage extends StatefulWidget {
  final List<QuestionResponse> response;
  final String link;

  const ColorAnimationPage({
    super.key,
    required this.response,
    required this.link,
  });

  @override
  ColorAnimationPageState createState() => ColorAnimationPageState();
}

class ColorAnimationPageState extends State<ColorAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = true; // To track loading state
  late double _percentage;
  late bool _isPass;
  late String? _code;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _percentage = 0;
    _isPass = false;
    _fetchTestResponse();
  }

  Future<void> _fetchTestResponse() async {
    try {
      QuestionService questionService = QuestionService(context);
      TestResult? testResult = await questionService.fetchTestResponse(
          widget.link,
          jsonEncode(TestResponse(widget.response, DateTime.now().toUtc(),
                  DateTime.now().toUtc())
              .toJson()));

      if (testResult != null) {
        setState(() {
          _isLoading = false;
          _percentage = testResult.percentage;
          _isPass = (Remark.PASS == testResult.remark) ? true : false;
          _controller.forward();
          _code = testResult.links['self']?.href.split('/').last;// Start animation after loading
        });
      } else {
        throw Exception('null responses');
      }
    } catch (error) {
      NoInternetPage(
        onRetry: () {
          setState(() {
            _isLoading = false;
          });
          _fetchTestResponse();
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 2.0 * _animation.value,
                      // Animate the radius to fill the screen
                      colors: [
                        !_isPass ? Colors.red : Colors.green,
                        Colors.transparent,
                      ],
                      stops: [_animation.value, _animation.value + 0.1],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        !_isPass ? Icons.thumb_down : Icons.thumb_up,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        !_isPass
                            ? 'Better luck next time!'
                            : 'Congratulations! You passed!',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your score: ${_percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(onPressed: () {
                              Share.share('Hey checkout this test from VetScholar https://vetscholar.app/?code=$_code');
                          }, child: const Row(children: [
                            Icon(Icons.share),
                            Text('Share Test')
                          ],)),
                          const SizedBox(width: 12,),
                          FilledButton.tonal(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const SubjectListPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.home),
                                 Text(' Home'),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                );
              },
            ),
    );
  }
}
