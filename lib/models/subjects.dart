class Subject {
  final id;
  final String name;
  final String selfLink;
  final String questionsLink;

  Subject({required this.id,required this.name, required this.selfLink, required this.questionsLink});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      selfLink: json['_links']['self']['href'],
      questionsLink: json['_links']['random-test']['href'],
    );
  }
}