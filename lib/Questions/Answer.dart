class Answer {
  final String text;

  Answer({required this.text});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(text: json['text']);
  }
}