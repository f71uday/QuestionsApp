import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:VetScholar/service/bookmark_service.dart';
import 'package:VetScholar/service/context_utility.dart';
import 'package:VetScholar/service/question_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  Set<int> _expandedTiles = Set<int>();

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
        // Initialize or update expansion state list
        _expandedTiles = Set<int>();
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

  Widget _buildQuestionTile(
      QuestionResponses questionResponse, int index, bool isExpanded) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _toggleBookmark(_bookmarked,index);
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.bookmark,
            label: 'Remove Bookmark',
          ),
        ],
      ),
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
              child: _expandedTiles.contains(index)
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
                            'Answer: ',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary),
                          ),
                          Expanded(
                            child: Text(
                              questionResponse.question.answer.text ??
                                  'No Answer Available',
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
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(height: 1.0);
          },
          itemCount: _bookmarked.length,
          itemBuilder: (context, index) {
            final bookmarked = _bookmarked[index];
            bool isExpanded = _expandedTiles.contains(index);
            return _buildQuestionTile(bookmarked, index, isExpanded);
          },
        ),
      ),
    );
  }

  void _toggleBookmark(List<QuestionResponses> questionResponse, int index) {
    // Your implementation for toggling bookmark
    setState(() {
      questionResponse.removeAt(index);
    });
    BookmarkService(ContextUtility.context!).removeBookmark(questionResponse[index].question.id);
  }



  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}