class Option {
  final String text;

  Option({required this.text});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(text: json['text']);
  }

}