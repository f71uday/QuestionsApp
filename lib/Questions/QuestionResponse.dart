class QuestionResponse {
  final int questionId;
  final String answer;

  QuestionResponse({required this.questionId, required this.answer});

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'answer': answer,
  };
}

class TestResponse {
  final List<QuestionResponse> questionResponses;

  TestResponse({required this.questionResponses});

  Map<String, dynamic> toJson() => {
    'questionResponses': questionResponses.map((qr) => qr.toJson()).toList(),
  };
}