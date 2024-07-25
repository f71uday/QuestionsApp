
import 'Answer.dart';
import 'Option.dart';

class Question {
  final String text;
  final List<Option> options;
  final Answer answer;


  Question({
    required this.text,
    required this.options,
    required this.answer,

  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: (json['options'] as List).map((i) => Option.fromJson(i)).toList(),
      answer: Answer.fromJson(json['answer']),

    );
  }

}





