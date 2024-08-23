import 'package:VetScholar/models/test_history.dart';
import 'package:VetScholar/service/test_history_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestHistoryPage extends StatefulWidget {
   TestHistoryPage({super.key});

  @override
  TestHistoryPageState createState() => TestHistoryPageState();
}

class TestHistoryPageState extends State<TestHistoryPage> {
  late List<TestResponseEvaluation> _testResults = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTestHistory();
  }

  Future<void> _fetchTestHistory() async {
    try {
     TestHistoryServices services = TestHistoryServices(context);
     http.Response response = await services.fetchHistory();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final TestHistory testHistory = TestHistory.fromJson(data);
        setState(() {
          _testResults = testHistory.embedded.testResponseEvaluations;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('Failed to load data.'))
          : ListView.builder(
        itemCount: _testResults.length,
        itemBuilder: (context, index) {
          final testResult = _testResults[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test Result',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('Score: ${testResult.score} / ${testResult.totalQuestions}'),
                  Text('Percentage: ${testResult.percentage.toStringAsFixed(2)}%'),
                  Text('Correct Answers: ${testResult.correctAnswers}'),
                  Text('Incorrect Answers: ${testResult.incorrectAnswers}'),
                  Text('Remarks: ${testResult.remarks ?? "N/A"}'),
                  Text('Time Taken: ${testResult.timeTaken}'),
                  Text('Date Taken: ${testResult.createdAt.toLocal()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}