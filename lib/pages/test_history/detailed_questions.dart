import 'package:VetScholar/models/paged_response.dart';
import 'package:VetScholar/models/test_result/question.dart';
import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/pages/constants/string_constants.dart';
import 'package:VetScholar/pages/quiz_page.dart';
import 'package:VetScholar/service/bookmark_service.dart';
import 'package:VetScholar/ui/flag_question.dart';
import 'package:VetScholar/ui/vet_scholar_custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late List<Questions> _skippedResponses = [];
  late bool _isLoading = true;
  late bool _hasError = false;
  final Set<int> _expandedTiles =
      {}; // Set to track expanded tiles for question responses
  bool _isExpandedSkipped = false; // Tracks if skipped questions are expanded
  bool _isExpandedResponses = true; // Tracks if question responses are expanded
  String _selfLink = '';

  Color _getColor(QuestionResponses questionResponse) {
    return questionResponse.result == Result.CORRECT
        ? Colors.green
        : Colors.red;
  }

  bool _isPass(QuestionResponses questionResponse) {
    return questionResponse.result == Result.CORRECT;
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails(widget.questionResponseUrl);
  }

  _toggleBookmark(QuestionResponses question) {
    question.question.isBookMarked!
        ? BookmarkService(context).removeBookmark(question.question.id)
        : BookmarkService(context).addBookmark(question.question.id);
    setState(() {
      question.question.isBookMarked =
          question.question.isBookMarked! ? false : true;
    });
  }

  _toggleSkippedBookmark(Questions question) {
    question.isBookMarked!
        ? BookmarkService(context).removeBookmark(question.id)
        : BookmarkService(context).addBookmark(question.id);
    setState(() {
      question.isBookMarked = question.isBookMarked! ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testName),
        actions: [
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton.filled(
              padding: const EdgeInsets.all(0.0),
              iconSize: 18,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizPage(selectedSubjects: null, testLink: _selfLink),
                    ));
              },
              icon: const Icon(Icons.replay),
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text(StringConstants.failedToLoad))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Card for Skipped Questions
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_isExpandedResponses) {
                                _isExpandedResponses = false;
                              }
                              _isExpandedSkipped = !_isExpandedSkipped;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // Ensure the shape is applied
                            child: ExpansionPanelList(
                              expansionCallback: (panelIndex, isExpanded) {
                                setState(() {
                                  if (_isExpandedResponses) {
                                    _isExpandedResponses = false;
                                  }
                                  _isExpandedSkipped = !_isExpandedSkipped;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return const ListTile(
                                      title: Text(
                                          StringConstants.skippedQuestions),
                                    );
                                  },
                                  body: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _skippedResponses.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      final skippedQuestion =
                                          _skippedResponses[index];
                                      final isExpanded =
                                          _expandedTiles.contains(index);

                                      return _buildSkippedQuestionTile(
                                          skippedQuestion, index, isExpanded);
                                    },
                                  ),
                                  isExpanded: _isExpandedSkipped,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card for Question Responses
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_isExpandedSkipped) {
                                _isExpandedSkipped = false;
                              }
                              _isExpandedResponses = !_isExpandedResponses;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // Ensure the shape is applied
                            child: ExpansionPanelList(
                              expansionCallback: (panelIndex, isExpanded) {
                                setState(() {
                                  if (_isExpandedSkipped) {
                                    _isExpandedSkipped = false;
                                  }
                                  _isExpandedResponses = !_isExpandedResponses;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return const ListTile(
                                      title: Text(
                                          StringConstants.attemptedQuestions),
                                    );
                                  },
                                  body: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _questionResponses.length,
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) {
                                      final questionResponse =
                                          _questionResponses[index];
                                      final isExpanded =
                                          _expandedTiles.contains(index);

                                      return _buildQuestionTile(
                                          questionResponse, index, isExpanded);
                                    },
                                  ),
                                  isExpanded: _isExpandedResponses,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQuestionTile(
      QuestionResponses questionResponse, int index, bool isExpanded) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _toggleBookmark(questionResponse);
            },
            backgroundColor: questionResponse.question.isBookMarked!
                ? Colors.orange
                : Colors.blue,
            foregroundColor: Colors.white,
            icon: questionResponse.question.isBookMarked!
                ? Icons.bookmark
                : Icons.bookmark_add_outlined,
            label: questionResponse.question.isBookMarked!
                ? StringConstants.removeBookmark
                : StringConstants.addBookmark,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              FlagQuestion.showFlagOptions(questionResponse.question);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.flag_outlined,
            label: StringConstants.labelFlag,
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      child: VetScholarCustomIcons.bookmarkedAnswer(
                          _isPass(questionResponse))),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                  )
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              child: isExpanded
                  ? SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  StringConstants.yourResponses,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Expanded(
                                  child: Text(
                                    questionResponse.userAnswer!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: _getColor(questionResponse)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  StringConstants.correctAnswer,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Expanded(
                                  child: Text(
                                    questionResponse.question.answer.text,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: questionResponse.question.topics
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
  }

  Future<void> _fetchQuestionDetails(String questionResponseUrl) async {
    try {
      TestHistoryServices service = TestHistoryServices(context);
      PagedResponse? response =
          await service.fetchTestQuestions(questionResponseUrl);
      String? testUrl = dotenv.env['TESTWITHID'];

      setState(() {
        _questionResponses = response!.questionResponses!;
        _skippedResponses = response.skippedQuestions!;
        _isLoading = false;
        _hasError = false;
        _selfLink = testUrl!.replaceFirst(
            '{testId}', response.links!['self']!.href.split('/').last);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildSkippedQuestionTile(
      Questions skippedQuestion, int index, bool isExpanded) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
              onPressed: (context) {
                _toggleSkippedBookmark(skippedQuestion);
              },
              backgroundColor:
                  skippedQuestion.isBookMarked! ? Colors.orange : Colors.blue,
              foregroundColor: Colors.white,
              icon: skippedQuestion.isBookMarked!
                  ? Icons.bookmark
                  : Icons.bookmark_add_outlined,
              label: skippedQuestion.isBookMarked!
                  ? StringConstants.removeBookmark
                  : StringConstants.addBookmark),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              FlagQuestion.showFlagOptions(skippedQuestion);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.flag_outlined,
            label: StringConstants.labelFlag,
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              title: Text(
                skippedQuestion.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(child: Icon(Icons.block)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                  )
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              child: isExpanded
                  ? SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  StringConstants.correctAnswer,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Expanded(
                                  child: Text(
                                    skippedQuestion.answer.text,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: skippedQuestion.topics
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
  }
}
