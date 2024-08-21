class TestResult {
  final int score;
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final String? remarks;
  final String shortRemark;
  final Duration timeTaken;
  final DateTime createdAt;

  TestResult({
    required this.score,
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    this.remarks,
    required this.shortRemark,
    required this.timeTaken,
    required this.createdAt,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      score: json['score'],
      percentage: json['percentage'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      remarks: json['remarks'],
      shortRemark: json['shortRemark'],
      timeTaken: _parseDuration(json['timeTaken']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'percentage': percentage,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'remarks': remarks,
      'shortRemark': shortRemark,
      'timeTaken': timeTaken.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Duration _parseDuration(String duration) {
    return Duration(
      minutes: int.parse(duration.substring(2, duration.length - 1)),
    );
  }
}