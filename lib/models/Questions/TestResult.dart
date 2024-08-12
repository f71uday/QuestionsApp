class TestResponse {
  final String userId;
  final List<ResponseData> responses;
  final DateTime? testStartedAt;
  final DateTime? testEndedAt;
  final DateTime createdAt;

  TestResponse({
    required this.userId,
    required this.responses,
    this.testStartedAt,
    this.testEndedAt,
    required this.createdAt,
  });

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    return TestResponse(
      userId: json['userId'],
      responses: List<ResponseData>.from(
        json['responses'].map((response) => ResponseData.fromJson(response)),
      ),
      testStartedAt: json['testStartedAt'] != null
          ? DateTime.parse(json['testStartedAt'])
          : null,
      testEndedAt: json['testEndedAt'] != null
          ? DateTime.parse(json['testEndedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'responses': responses.map((response) => response.toJson()).toList(),
      'testStartedAt': testStartedAt?.toIso8601String(),
      'testEndedAt': testEndedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ResponseData {
  final String userId;
  final String answerType;
  final Map<String, String> answerValue;
  final Map<String, String> evaluation;
  final DateTime? timeTaken;
  final DateTime createdAt;

  ResponseData({
    required this.userId,
    required this.answerType,
    required this.answerValue,
    required this.evaluation,
    this.timeTaken,
    required this.createdAt,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      userId: json['userId'],
      answerType: json['answerType'],
      answerValue: Map<String, String>.from(json['answerValue']),
      evaluation: Map<String, String>.from(json['evaluation']),
      timeTaken:
      json['timeTaken'] != null ? DateTime.parse(json['timeTaken']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answerType': answerType,
      'answerValue': answerValue,
      'evaluation': evaluation,
      'timeTaken': timeTaken?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class TestResult {
  final TestResponse testResponse;
  final int score;
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final String? remarks;
  final String shortRemark;
  final String timeTaken;
  final DateTime createdAt;

  TestResult({
    required this.testResponse,
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
      testResponse: TestResponse.fromJson(json['testResponse']),
      score: json['score'],
      percentage: json['percentage'].toDouble(),
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      remarks: json['remarks'],
      shortRemark: json['shortRemark'],
      timeTaken: json['timeTaken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testResponse': testResponse.toJson(),
      'score': score,
      'percentage': percentage,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'remarks': remarks,
      'shortRemark': shortRemark,
      'timeTaken': timeTaken,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}