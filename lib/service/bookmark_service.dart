import 'package:VetScholar/service/question_service.dart';
import 'package:flutter/material.dart';

import '../models/test_result/question_responses.dart';
import '../ui/snack_bar.dart';

class BookmarkService {
  BuildContext context;

  BookmarkService(this.context);

  void removeBookmark(int id) {
    QuestionService(context).deleteBookMark(id);
    CustomSnackBar().showCustomToastWithCloseButton(
        context, Colors.green, Icons.remove, 'Removed from Bookmarks');
  }

  void addBookmark(int id) {
    QuestionService(context).createBookmark(id);
    CustomSnackBar().showCustomToastWithCloseButton(
        context, Colors.green, Icons.add, 'Added to Bookmarks');
  }
}
