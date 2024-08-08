

class TestResponseModel {
  TestResponse testResponse;
  int score;
  double percentage;
  int totalQuestions;
  int correctAnswers;
  int incorrectAnswers;
  String? remarks;
  String shortRemark;
  String timeTaken;
  DateTime createdAt;

  TestResponseModel({
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

  factory TestResponseModel.fromJson(Map<String, dynamic> json) {
    return TestResponseModel(
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

class TestResponse {
  String userId;
  List<Response> responses;
  DateTime? testStartedAt;
  DateTime? testEndedAt;
  DateTime createdAt;

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
      responses: (json['responses'] as List)
          .map((i) => Response.fromJson(i))
          .toList(),
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
      'responses': responses.map((i) => i.toJson()).toList(),
      'testStartedAt': testStartedAt?.toIso8601String(),
      'testEndedAt': testEndedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Response {
  String userId;
  String answerType;
  AnswerValue answerValue;
  Evaluation evaluation;
  dynamic timeTaken;
  DateTime createdAt;

  Response({
    required this.userId,
    required this.answerType,
    required this.answerValue,
    required this.evaluation,
    this.timeTaken,
    required this.createdAt,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      userId: json['userId'],
      answerType: json['answerType'],
      answerValue: AnswerValue.fromJson(json['answerValue']),
      evaluation: Evaluation.fromJson(json['evaluation']),
      timeTaken: json['timeTaken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answerType': answerType,
      'answerValue': answerValue.toJson(),
      'evaluation': evaluation.toJson(),
      'timeTaken': timeTaken,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class AnswerValue {
  String option;

  AnswerValue({
    required this.option,
  });

  factory AnswerValue.fromJson(Map<String, dynamic> json) {
    return AnswerValue(
      option: json['OPTION'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OPTION': option,
    };
  }
}

class Evaluation {
  String option;

  Evaluation({
    required this.option,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      option: json['OPTION'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OPTION': option,
    };
  }
}