
import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/service/bookmark_service.dart';
import 'package:VetScholar/ui/vet_scholar_custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/test_result/result.dart';
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

  Color _getColor(questionResponse) {
    return questionResponse.result == Result.CORRECT
        ? Colors.green
        : Colors.red;
  }

  bool _isPass(questionResponse) {
    return questionResponse.result == Result.CORRECT;
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails(widget.questionResponseUrl);
  }

  _toggleBookmark(QuestionResponses question) {
    question.question.isBookMarked
        ? BookmarkService(context).removeBookmark(question.question.id)
        : BookmarkService(context).addBookmark(question.question.id);
    setState(() {
      question.question.isBookMarked =
          question.question.isBookMarked ? false : true;
    });
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

                    return Slidable(
                      key: ValueKey(index),
                      // Define the start action pane
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _toggleBookmark(questionResponse);
                            },
                            backgroundColor:
                                questionResponse.question.isBookMarked
                                    ? Colors.orange
                                    : Colors.blue,
                            foregroundColor: Colors.white,
                            icon: questionResponse.question.isBookMarked
                                ? Icons.bookmark
                                : Icons.bookmark_add_outlined,
                            label: questionResponse.question.isBookMarked
                                ? 'Remove Bookmark'
                                : 'Add To Bookmark',
                          ),
                        ],
                      ),
                      // Define the end action pane
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Action for delete
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.flag_outlined,
                            label: 'Flag',
                          ),
                        ],
                      ),
                      child: GestureDetector(
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                      child: VetScholarCustomIcons
                                          .bookmarkedAnswer(
                                              _isPass(questionResponse))),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              reverseDuration:
                                  const Duration(milliseconds: 300),
                              curve: Curves.easeInOutBack,
                              child: isExpanded
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Your Response: ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    questionResponse
                                                        .userAnswer!,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: _getColor(
                                                            questionResponse)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Correct Answer: ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                                Text(
                                                  questionResponse
                                                      .question.answer.text,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: questionResponse
                                                  .question.topics
                                                  .map((tag) => Chip(
                                                        label: Text(tag.name),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
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
          await service.fetchTestQuestions(questionResponseUrl);
      setState(() {
        questionResponses!.sort((a, b) => a.question.id.compareTo(b.question.id));
        _questionResponses = questionResponses;
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
