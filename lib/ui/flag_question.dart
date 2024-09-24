import 'dart:developer';

import 'package:VetScholar/models/feedback/details.dart';
import 'package:VetScholar/models/feedback/entity_detail.dart';
import 'package:VetScholar/models/feedback/entity_type.dart';
import 'package:VetScholar/models/feedback/sentiment.dart';
import 'package:VetScholar/service/context_utility.dart';
import 'package:VetScholar/service/question_service.dart';
import 'package:VetScholar/ui/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:VetScholar/models/feedback/feedback.dart';

import '../models/test_result/question.dart';
import '../models/test_result/question_responses.dart';

class FlagQuestion {
  static void showFlagOptions(Questions questionResponse) {
    // List of flagging reasons
    final List<String> flagOptions = [
      'Incorrect Question',
      'Incorrect Answer',
      'Inappropriate Content',
      'Outdated Information',
      'Duplicate Content',
      'Unclear or Vague Question',
      'Technical Issue',
      'Spam or Promotional Content',
      'Irrelevant Topic',
      'Plagiarism',
    ];

    // Track selected chips using a Set
    Set<String> selectedFlags = <String>{};

    showModalBottomSheet(
      context: ContextUtility.context!,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Why are you flagging this content?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    // Create chips dynamically from the flagOptions list
                    children: flagOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: selectedFlags.contains(option),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedFlags.add(option);
                            } else {
                              selectedFlags.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: selectedFlags.isEmpty
                          ? null
                          : () {
                              handleFlagging(selectedFlags, questionResponse);
                              Navigator.pop(
                                  context); // Close the bottom sheet after selection
                            },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void handleFlagging(
      Set<String> selectedFlags, Questions question) {
    // Logic for handling multiple flag selections
    log('Flags submitted: ${selectedFlags.join(', ')}');
    UserFeedback feedback = UserFeedback(
        Sentiment.NEGATIVE,
        Details(null, null, null, selectedFlags.join(', '),
            EntityDetail(EntityType.QUESTION, question.id)));
    QuestionService(ContextUtility.context!).submitFeedBack(feedback);
    CustomSnackBar().showCustomToastWithCloseButton(
        ContextUtility.context!, Colors.orange, Icons.flag, 'Thank You for letting us know!');
  }
}
