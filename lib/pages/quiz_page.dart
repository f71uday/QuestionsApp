import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Questions/Question.dart';


class QuizPage extends StatefulWidget {
  final String questionLink ;

  QuizPage({required this.questionLink});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;
  Timer? _timer;
  Duration _remainingTime = Duration(minutes: 10);
  late Future<List<Question>> questions;

  @override
  void initState() {
    super.initState();
    questions = fetchQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - Duration(seconds: 1);
        }
        else {
          timer.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time is up!'),
        content: FutureBuilder<List<Question>>(
          future: questions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No questions available.');
            } else {
              return Text('Your score: $score/${snapshot.data!.length}');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formattedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      selectedOptionIndex = null;
    });
    Navigator.pop(context); // Close the drawer
  }

  void _nextQuestion() {
    setState(() {
      questions.then((questionList) {
        questionList[currentQuestionIndex].isAnswered = true;
        if (selectedOptionIndex != null &&
            questionList[currentQuestionIndex].answer.text ==
                questionList[currentQuestionIndex].options[selectedOptionIndex!].text) {
          score++;
        }
        currentQuestionIndex++;
        selectedOptionIndex = null;
      });
    });
  }

  void _skipQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(widget.questionLink));

    if (response.statusCode == 200) {
      return parseQuestions(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  List<Question> parseQuestions(String jsonString) {
    final parsed = json.decode(jsonString);
    final questionsJson = parsed['_embedded']['questions'] as List;
    return questionsJson.map((json) => Question.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: questions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Quiz App')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Quiz App')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Quiz App')),
            body: Center(child: Text('No questions available.')),
          );
        } else {
          List<Question> questions = snapshot.data!;
          if (currentQuestionIndex >= questions.length) {
            return Scaffold(
              appBar: AppBar(title: Text('Quiz App')),
              body: Center(child: Text('Your score: $score/${questions.length}')),
            );
          }

          Question currentQuestion = questions[currentQuestionIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                _formattedTime(_remainingTime),
                style: TextStyle(fontSize: 24.0, color: Colors.red),
              ),
              elevation: 5.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: _confirmEnd,
                      style: ElevatedButton.styleFrom(
                       // primary: Colors.red,
                        backgroundColor: Colors.red// Background color
                      ),
                      child: Text ('End', style: TextStyle(  fontWeight: FontWeight.bold,color: Colors.white),)),
                )
              ],
            ),
            // endDrawer: ElevatedButton(
            //   onPressed: () {  },
            //   child: Text ('End', style: TextStyle( backgroundColor: Colors.red, fontWeight: FontWeight.bold,color: Colors.white),),
            //
            // ),

            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Text(
                      'Quiz App',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  ListTile(
                    title: Text('Total Questions: ${questions.length}'),
                  ),
                  ListTile(
                    title: Text('Questions Attended: $currentQuestionIndex'),
                  ),
                  Divider(),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final color =  questions[currentQuestionIndex].isAnswered
                            ? Colors.blue
                            : Colors.white;
                        return GestureDetector(
                          onTap: () => _goToQuestion(index),
                          child: Card(
                            //TODO: update color of the card is it was attented
                            color: color,
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentQuestionIndex +1}. ' + currentQuestion.question,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 20.0),
                  ...currentQuestion.options.asMap().entries.map((option) {
                    final isSelected = option.key == selectedOptionIndex;
                    final isCorrect = option.value.text == currentQuestion.answer.text;
                    final color = isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.black;
                    return ListTile(
                      title: Text(
                        option.value.text,
                        style: TextStyle(color: color),
                      ),
                      leading: Radio<int>(
                        value: option.key,
                        groupValue: selectedOptionIndex,
                        onChanged: (value) {
                          setState(() {
                            selectedOptionIndex = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedOptionIndex == null ? null : _nextQuestion,
                          child: Text('Next'),
                          
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _skipQuestion,
                          child: Text('Skip'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  void _confirmEnd() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure want to end this quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/subjects'),
              child: Text('Yes'))
        ],
      ),
    );
  }
}