import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/service/question_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'error/no-intrnet.dart';

class BookmarkedQuestionsPage extends StatefulWidget {
  const BookmarkedQuestionsPage({super.key});

  @override
  BookmarkedQuestionsPageState createState() => BookmarkedQuestionsPageState();
}

class BookmarkedQuestionsPageState extends State<BookmarkedQuestionsPage>
    with AutomaticKeepAliveClientMixin {
  late List<QuestionResponses> _bookmarked = [];
  bool _isLoading = true;
  bool _hasError = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _currentPage = 0;
  bool _isLastPage = false;

  // To track expansion state
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    _fetchBookMarkedQuestions();
  }

  void _disableLoadWithError() {
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }

  void _disableLoadWithSuccess(List<QuestionResponses>? testResults) {
    setState(() {
      _bookmarked = testResults!;
      _isLoading = false;

      // Initialize the expansion state list with 'false' values (collapsed)
      _isExpandedList = List.filled(_bookmarked.length, false);
    });
  }

  Future<void> _fetchBookMarkedQuestions(
      {bool isRefresh = false, bool isLoadMore = false}) async {
    if (isLoadMore && _isLastPage) {
      _refreshController.loadNoData();
      return;
    }

    try {
      QuestionService services = QuestionService(context);
      List<QuestionResponses> newResults =
          await services.getBookMarked(page: _currentPage);
      if (newResults.isNotEmpty) {
        if (isRefresh) {
          _bookmarked = newResults;
        } else {
          _bookmarked.addAll(newResults);
        }
        _isLoading = false;

        if (isLoadMore) {
          _refreshController.loadComplete();
          _currentPage++;
        } else if (isRefresh) {
          _refreshController.refreshCompleted();
          _currentPage = 2; // Reset to the next page
        }
        // Update the expansion state list after loading new data
        _isExpandedList = List.filled(_bookmarked.length, false);
      } else {
        _isLastPage = true;
        if (isLoadMore) {
          _refreshController.loadNoData();
        } else if (isRefresh) {
          _refreshController.refreshCompleted();
        }
      }
      _disableLoadWithSuccess(_bookmarked);
    } catch (error) {
      _disableLoadWithError();
      if (isRefresh) {
        _refreshController.refreshFailed();
      } else if (isLoadMore) {
        _refreshController.loadFailed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? NoInternetPage(
                  onRetry: () {
                    setState(() {
                      _isLoading = true;
                      _hasError = false;
                    });
                    _fetchBookMarkedQuestions();
                  },
                )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _fetchBookMarkedQuestions(isRefresh: true),
                  enablePullUp: true,
                  onLoading: () => _fetchBookMarkedQuestions(isLoadMore: true),
                  child: SingleChildScrollView(
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _isExpandedList[index] = isExpanded;
                        });
                      },
                      children: _bookmarked
                          .asMap()
                          .entries
                          .map<ExpansionPanel>((entry) {
                        int index = entry.key;
                        QuestionResponses bookmarked = entry.value;
                        return
                          ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(
                                bookmarked.question.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
                          body: ListTile(
                            title: Text(bookmarked.question.answer.text ??
                                'No Answer Available'),
                          ),
                          isExpanded: _isExpandedList[index],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
