
import 'Answer.dart';
import 'Option.dart';
import 'Topics.dart';

class Question {
  final String question;
  final List<Option> options;
  final Answer answer;
  bool isAnswered;
  final List<Topic> topics;
  final int id;
  Question({
    this.isAnswered = false,
    required this.question,
    required this.options,
    required this.answer,
    required this.topics,
    required this.id

  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['text'],
      id: json['id'],
      options: (json['options'] as List).map((i) => Option.fromJson(i)).toList(),
      answer: Answer.fromJson(json['answer']),
        isAnswered: false,
        topics: (json['topics'] as List).map((i) => Topic.fromJson(i)).toList(),
    );
  }

}





