
import 'Answer.dart';
import 'Option.dart';

class Question {
  final String question;
  final List<Option> options;
  final Answer answer;
  bool isAnswered;

  Question({
    this.isAnswered = false,
    required this.question,
    required this.options,
    required this.answer,

  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['text'],
      options: (json['options'] as List).map((i) => Option.fromJson(i)).toList(),
      answer: Answer.fromJson(json['answer']),
        isAnswered: false
    );
  }

}





