class Topic {
  final String name;

  Topic({required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json['name'],
    );
  }
}