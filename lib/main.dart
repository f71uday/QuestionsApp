import 'package:flutter/material.dart';
import 'package:flutter_application_2/signin_page.dart';
import 'question.dart'; // Import the Question model

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => SignInPage(),
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

  // List of questions
  List<Question> questions = [
    Question(
      questionText: 'What is the capital of France?',
      options: ['Paris', 'London', 'Berlin', 'Madrid'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which planet is known as the Red Planet?',
      options: ['Earth', 'Mars', 'Jupiter', 'Venus'],
      correctAnswerIndex: 1,
    ),
    // Add more questions here
  ];

  void _nextQuestion() {
    if (selectedOptionIndex != null &&
        questions[currentQuestionIndex].correctAnswerIndex ==
            selectedOptionIndex) {
      score++;
    }

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

  @override
  Widget build(BuildContext context) {
    if (currentQuestionIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz App')),
        body: Center(child: Text('Your score: $score/${questions.length}')),
      );
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        // Use theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ...currentQuestion.options.asMap().entries.map((option) {
              final isSelected = option.key == selectedOptionIndex;
              final isCorrect =
                  option.key == currentQuestion.correctAnswerIndex;
              final color = isSelected
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.black;
              return ListTile(
                title: Text(
                  option.value,
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
                    onPressed:
                        selectedOptionIndex == null ? null : _nextQuestion,
                    child: Text('Next'),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _skipQuestion,
                    child: Text(
                      'Skip',
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
}
