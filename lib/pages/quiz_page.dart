import 'dart:async';

import 'package:VetScholar/pages/view/quiz_result.dart';
import 'package:flutter/material.dart';

import '../models/Questions/Question.dart';
import '../models/Questions/QuestionResponse.dart';
import '../service/question_service.dart';

class QuizPage extends StatefulWidget {
  final String questionLink;
  final String subjectName;

  QuizPage({
    required this.questionLink,
    required this.subjectName,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;
  Timer? _timer;
  Duration _remainingTime = Duration(minutes: 10);
  late Future<List<Question>> questions;
  bool isActive = true; // flag to check if the page is active
  bool? isPassed;
  final List<String> tags = ["no tags"];

  late final QuestionService _questionService;
  List<QuestionResponse> response = [];
  @override
  void initState() {
    super.initState();
    _questionService = QuestionService(context);
    questions = _questionService.fetchQuestions(widget.questionLink);
    _startTimer();
  }

  @override
  void dispose() {
    isActive = false; // set the flag to false when disposing
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isActive) {
        timer.cancel();
      } else {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - Duration(seconds: 1);
          } else {
            timer.cancel();
            _showTimeUpDialog();
          }
        });
      }
    });
  }

  void _showTimeUpDialog() {
    if (!mounted) return; // check if the widget is still in the tree
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

  Color _getTimerTextColor() {
    return _remainingTime.inMinutes >= 2 ? Colors.green : Colors.red;
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
                questionList[currentQuestionIndex]
                    .options[selectedOptionIndex!]
                    .text) {
          score++;



        }
        insertOrReplace(response,currentQuestionIndex,QuestionResponse(
            questionId: questionList[currentQuestionIndex].id,
            answer: questionList[currentQuestionIndex]
                .options[selectedOptionIndex!]
                .text));
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
  void insertOrReplace(List<QuestionResponse> list, int index, QuestionResponse value) {
    if (index < list.length) {
      list[index] = value; // Replace
    } else {
      list.add(value); // Insert at the end
    }
  }
  bool isPageDisposed() {
    return !mounted;
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
            double _percentage = (score / questions.length) * 100;
            bool _isPassed = _percentage > 60;

            // Navigate to the ColorAnimationPage when the quiz ends
            return ColorAnimationPage(
              response: response,
              link: _questionService.fetchResponseLink(),

            );
          }

          Question currentQuestion = questions[currentQuestionIndex];

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                _formattedTime(_remainingTime),
                style: TextStyle(fontSize: 24.0, color: _getTimerTextColor()),
              ),
              elevation: 5.0,
              actions: [
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ],
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    'tags',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Divider(),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: currentQuestion.topics
                        .map((tag) => Chip(
                              label: Text(tag.name),
                              backgroundColor:
                                  const Color.fromARGB(100, 213, 212, 212),
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ))
                        .toList(),
                  ),
                  const Padding(padding: EdgeInsets.all(20))
                ],
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Text(
                      '${widget.subjectName} Quiz',
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
                        final color = questions[index].isAnswered
                            ? Colors.blue
                            : Colors.white;
                        return GestureDetector(
                          onTap: () => _goToQuestion(index),
                          child: Card(
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
                  Divider(),
                  //Padding(padding: EdgeInsets.all(8)),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _confirmEnd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Background color
                          ),
                          child: Text(
                            'End',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentQuestionIndex + 1}. ' + currentQuestion.question,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 20.0),
                  ...currentQuestion.options.asMap().entries.map((option) {
                    final isSelected = option.key == selectedOptionIndex;
                    final isCorrect =
                        option.value.text == currentQuestion.answer.text;
                    final color = isSelected
                        ? (isCorrect ? Colors.green : Colors.red)
                        : Colors.black;
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
                          onPressed: selectedOptionIndex == null
                              ? null
                              : _nextQuestion,
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
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/subjects'),
              child: Text('Yes'))
        ],
      ),
    );
  }
}
