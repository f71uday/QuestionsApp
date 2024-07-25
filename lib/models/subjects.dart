class Subject {
  final String name;
  final String selfLink;
  final String questionsLink;

  Subject({required this.name, required this.selfLink, required this.questionsLink});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      selfLink: json['_links']['self']['href'],
      questionsLink: json['_links']['questions']['href'],
    );
  }
}