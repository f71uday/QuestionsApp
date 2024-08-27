import 'dart:ffi';

import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:flutter/material.dart';

import '../../service/test_history_services.dart';

class DetailedQuestionsPage extends StatefulWidget {
  final String questionResponseUrl;
  final String testName;

  const DetailedQuestionsPage(this.questionResponseUrl, this.testName,
      {super.key});

  @override
  DetailedQuestionsPageState createState() => DetailedQuestionsPageState();
}

class DetailedQuestionsPageState extends State<DetailedQuestionsPage> {
  late List<QuestionResponses> _questionResponses = [];
  late bool _isLoading = true;
  late bool _hasError = false;
  final Set<int> _expandedTiles = {}; // Set to track expanded tiles

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails(widget.questionResponseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('Failed to load data.'))
              : ListView.separated(
                  itemCount: _questionResponses.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final questionResponse = _questionResponses[index];
                    final isExpanded = _expandedTiles.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedTiles.remove(index);
                          } else {
                            _expandedTiles.add(index);
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            title: Text(
                              questionResponse.question.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            reverseDuration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutBack,
                            child: isExpanded
                                ? Container(
                                    color:
                                        const Color.fromRGBO(138, 43, 226, 0.1),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Answer: ${questionResponse.userAnswer}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Result: ${questionResponse.result}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _fetchQuestionDetails(String questionResponseUrl) async {
    try {
      TestHistoryServices service = TestHistoryServices(context);
      List<QuestionResponses>? questionResponses =
          await service.fetchTestQuestions(Uri.parse(questionResponseUrl));
      setState(() {
        _questionResponses = questionResponses!;
        _isLoading = false;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }
}
