import 'dart:async';

import 'package:VetScholar/pages/error/no-intrnet.dart';
import 'package:VetScholar/pages/view/quiz_result.dart';
import 'package:VetScholar/service/bookmark_service.dart';
import 'package:flutter/material.dart';

import '../models/Questions/question.dart';
import '../models/Questions/QuestionResponse.dart';
import '../service/question_service.dart';

class QuizPage extends StatefulWidget {
  final String? selectedSubjects;
  final String testLink;

  const QuizPage(
      {super.key, required this.selectedSubjects, required this.testLink});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;
  Timer? _timer;
  Duration _remainingTime = const Duration(minutes: 10);
  late Future<List<Question>> questions;
  bool isActive = true; // flag to check if the page is active
  bool? isPassed;
  final List<String> tags = ["no tags"];

  late final QuestionService _questionService;
  List<QuestionResponse> response = [];
  bool _showPreview = true; // Flag to show quiz preview

  @override
  void initState() {
    super.initState();
    _questionService = QuestionService(context);
    questions = _questionService.fetchQuestions(
        widget.selectedSubjects, widget.testLink);
  }

  @override
  void dispose() {
    isActive = false; // set the flag to false when disposing
    _timer?.cancel();
    super.dispose();
  }

  void _startQuiz() {
    setState(() {
      _showPreview = false; // Hide preview and start the quiz
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive) {
        timer.cancel();
      } else {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
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
        title: const Text('Time is up!'),
        content: FutureBuilder<List<Question>>(
          future: questions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return noInternet();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No questions available.');
            } else {
              return Text('Your score: $score/${snapshot.data!.length}');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _timer?.cancel();
              isActive = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ColorAnimationPage(
                          response: response,
                          link: _questionService.getResponseLink(),
                        )),
              );
            },
            child: const Text('OK'),
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

        QuestionResponse questionResponse = QuestionResponse(
          questionList[currentQuestionIndex].id,
          questionList[currentQuestionIndex].options[selectedOptionIndex!].text,
          DateTime.now().toUtc(),
          DateTime.now().toUtc(),
        );

        insertOrReplace(response, currentQuestionIndex, questionResponse);

        currentQuestionIndex++;
        selectedOptionIndex = null;
      });
    });
  }

  void _showBottomSheet(Question currentQuestion) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          // Adjusted padding for better spacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Ensures the bottom sheet height is minimal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: currentQuestion.topics
                    .map((tag) => Chip(
                          label: Text(tag.name),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              // Add space before any additional buttons
            ],
          ),
        );
      },
    );
  }

  void _skipQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = null;
    });
  }

  void insertOrReplace(
      List<QuestionResponse> list, int index, QuestionResponse value) {
    if (index < list.length) {
      list[index] = value; // Replace
    } else {
      list.add(value); // Insert at the end
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showPreview) {
      return PopScope(
        canPop: false,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _startQuiz,
              child: const Icon(Icons.arrow_forward),
            ),
            appBar: AppBar(
              title: const Text('Preview'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Question>>(
                future: questions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return noInternet();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No questions available.');
                  } else {
                    final questionCount = snapshot.data!.length;
                    return Column(
                      children: [
                        Text(
                          _questionService.getQuizName(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 75,
                        ),
                        const Row(
                          children: [
                            Text("Specifications"),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.question_mark_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Total Questions ',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              '$questionCount',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.timer_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Total Time ',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              '${_formattedTime(_remainingTime)} Min',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            )),
      );
    }

    return PopScope(
      canPop: false,
      child: FutureBuilder<List<Question>>(
        future: questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text('Quiz App')),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return noInternet();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Quiz App')),
              body: const Center(child: Text('No questions available.')),
            );
          } else {
            List<Question> questions = snapshot.data!;

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
                    icon: currentQuestion.isBookmarked
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_add_outlined),
                    onPressed: () {
                      _addOrRemoveBookmark(currentQuestion);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      _showBottomSheet(currentQuestion);
                    },
                  )
                ],
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          Text(
                            '${_questionService.getQuizName()} Quiz',
                            style: const TextStyle(fontSize: 30.0),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text('Total Questions: ${questions.length}'),
                    ),
                    ListTile(
                      title: Text('Questions Attended: $currentQuestionIndex'),
                    ),
                    const Divider(),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final color = questions[index].isAnswered
                              ? Colors.green
                              : Colors.red;
                          return GestureDetector(
                            onTap: () => _goToQuestion(index),
                            child: Card(
                              color: color,
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: _confirmEnd,
                            child: const Text(
                              'End',
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
                      '${currentQuestionIndex + 1}. ${currentQuestion.question}',
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(height: 20.0),
                    ...currentQuestion.options.asMap().entries.map((option) {
                      return ListTile(
                        title: Text(
                          option.value.text,
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
                    }),
                    const Spacer(),
                    if (!_isLastQuestion(questions))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: _skipQuestion,
                              child: const Text('Skip'),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10.0)),
                          Expanded(
                            child: FilledButton(
                              onPressed: selectedOptionIndex == null
                                  ? null
                                  : _nextQuestion,
                              child: const Text('Next'),
                            ),
                          ),
                        ],
                      ),
                    if (_isLastQuestion(questions))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: _scaffoldKey.currentState!.openDrawer,
                              child: const Text('Navigate'),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10.0)),
                          Expanded(
                            child: FilledButton(
                              onPressed: selectedOptionIndex == null
                                  ? null
                                  : _confirmEnd,
                              child: const Text(
                                'End',
                                style: TextStyle(color: Colors.white),
                              ),
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
      ),
    );
  }

  bool _isLastQuestion(List<Question> questions) =>
      currentQuestionIndex == questions.length - 1;

  void _confirmEnd() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure want to end this quiz?'),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          FilledButton(
              onPressed: () {
                _timer?.cancel();
                isActive = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ColorAnimationPage(
                            response: response,
                            link: _questionService.getResponseLink(),
                          )),
                );
              },
              child: const Text('Yes'))
        ],
      ),
    );
  }

  NoInternetPage noInternet() {
    return NoInternetPage(
      onRetry: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
  }

  _addOrRemoveBookmark(Question currentQuestion) async {
    setState(() {
      currentQuestion.isBookmarked =
          currentQuestion.isBookmarked ? false : true;
    });
    currentQuestion.isBookmarked
        ? BookmarkService(context).addBookmark(currentQuestion.id)
        : BookmarkService(context).removeBookmark(currentQuestion.id);
  }
}
