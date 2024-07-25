import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'Questions/Question.dart';
import 'config/Config.dart'; // Ensure you have your model files in the correct directory

void main() {
  runApp(QuizApp());
}
Future<Config> loadConfig() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final jsonResponse = json.decode(jsonString);
  return Config.fromJson(jsonResponse);
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/quiz',
      routes: {

        '/quiz': (context) => QuizPage()
      },
    );
  }
}

class QuizPage extends StatefulWidget {
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
        } else {
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
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  void _skipQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse('http://localhost/questions?page=0&size=20'));

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
            ),
            drawer: Drawer(
              child: ListView(
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
                  ...questions.asMap().entries.map((entry) {
                    int index = entry.key;
                    return ListTile(
                      title: Text('Question ${index + 1}'),
                      onTap: () => _goToQuestion(index),
                    );
                  }).toList(),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.text,
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
}