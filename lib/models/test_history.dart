class TestResponseEvaluation {
  final int score;
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final String? remarks;
  final String shortRemark;
  final String timeTaken;
  final DateTime createdAt;
  final Links links;

  TestResponseEvaluation({
    required this.score,
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    this.remarks,
    required this.shortRemark,
    required this.timeTaken,
    required this.createdAt,
    required this.links,
  });

  factory TestResponseEvaluation.fromJson(Map<String, dynamic> json) {
    return TestResponseEvaluation(
      score: json['score'],
      percentage: json['percentage'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      remarks: json['remarks'],
      shortRemark: json['shortRemark'],
      timeTaken: json['timeTaken'],
      createdAt: DateTime.parse(json['createdAt']),
      links: Links.fromJson(json['_links']),
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
      'timeTaken': timeTaken,
      'createdAt': createdAt.toIso8601String(),
      '_links': links.toJson(),
    };
  }
}

class Links {
  final Link self;
  final Link testResponseEvaluation;
  final Link testResponse;

  Links({
    required this.self,
    required this.testResponseEvaluation,
    required this.testResponse,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: Link.fromJson(json['self']),
      testResponseEvaluation: Link.fromJson(json['testResponseEvaluation']),
      testResponse: Link.fromJson(json['testResponse']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self.toJson(),
      'testResponseEvaluation': testResponseEvaluation.toJson(),
      'testResponse': testResponse.toJson(),
    };
  }
}

class Link {
  final String href;

  Link({required this.href});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
    };
  }
}

class Embedded {
  final List<TestResponseEvaluation> testResponseEvaluations;

  Embedded({required this.testResponseEvaluations});

  factory Embedded.fromJson(Map<String, dynamic> json) {
    var list = json['testResponseEvaluations'] as List;
    List<TestResponseEvaluation> testResponseEvaluationsList =
    list.map((i) => TestResponseEvaluation.fromJson(i)).toList();

    return Embedded(testResponseEvaluations: testResponseEvaluationsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'testResponseEvaluations':
      testResponseEvaluations.map((e) => e.toJson()).toList(),
    };
  }
}

class TestHistory {
  final Embedded embedded;

  TestHistory({required this.embedded});

  factory TestHistory.fromJson(Map<String, dynamic> json) {
    return TestHistory(
      embedded: Embedded.fromJson(json['_embedded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_embedded': embedded.toJson(),
    };
  }
}

/*
Sample Response 
{
    "_embedded": {
        "testResponseEvaluations": [
            {
                "score": 2,
                "percentage": 100.0,
                "totalQuestions": 2,
                "correctAnswers": 2,
                "incorrectAnswers": 0,
                "remarks": null,
                "shortRemark": "PASS",
                "timeTaken": "PT5M",
                "createdAt": "2024-08-08T19:40:36.289265+05:30",
                "_links": {
                    "self": {
                        "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations/ab161264-16d3-4d2d-9eed-f9dd7ec6018c"
                    },
                    "testResponseEvaluation": {
                        "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations/ab161264-16d3-4d2d-9eed-f9dd7ec6018c"
                    },
                    "testResponse": {
                        "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations/ab161264-16d3-4d2d-9eed-f9dd7ec6018c/testResponse"
                    }
                }
            }
        ]
    },
    "_links": {
        "first": {
            "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations?page=0&size=20"
        },
        "self": {
            "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations?page=0&size=20"
        },
        "next": {
            "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations?page=1&size=20"
        },
        "last": {
            "href": "http://f71uday.ddns.net:8080/api/testResponseEvaluations?page=1&size=20"
        }
    },
    "page": {
        "size": 20,
        "totalElements": 36,
        "totalPages": 2,
        "number": 0
    }
}
 */