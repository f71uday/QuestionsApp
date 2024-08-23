

import 'package:VetScholar/models/test_history.dart';
import 'package:VetScholar/service/test_history_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class TestHistoryPage extends StatefulWidget {
  TestHistoryPage({super.key});

  @override
  TestHistoryPageState createState() => TestHistoryPageState();
}

class TestHistoryPageState extends State<TestHistoryPage> {
  late List<TestResponseEvaluation> _testResults = [];
  DateFormat formatter = DateFormat('dd-MM-yyyy');
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

  MaterialColor getColor(String text) {
    if (text == 'PASS') return Colors.green;
    else return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('Failed to load data.'))
          : ListView.separated(
       
        itemCount: _testResults.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final testResult = _testResults[index];
          return ListTile(
            onTap: () => print("tapped"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            title: Text(
              'Test Result',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Score: ${testResult.score} / ${testResult.totalQuestions}'),
                Text('Appeared on: ${formatter.format(testResult.createdAt.toLocal())}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text(
                      '${testResult.percentage.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 16, color: getColor(testResult.shortRemark)),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}