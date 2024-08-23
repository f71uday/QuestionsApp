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
  late List<TestResponseEvaluation> _filteredResults = [];
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  bool _isLoading = true;
  bool _hasError = false;
  String _sortOption = 'Date'; // Default sort option
  String _filterOption = 'All'; // Default filter option

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
          _applyFilter(); // Apply filter after fetching data
          _sortTestResults(); // Sort after filtering
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

  void _sortTestResults() {
    switch (_sortOption) {
      case 'Date':
        _filteredResults.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Percentage':
        _filteredResults.sort((a, b) => b.percentage.compareTo(a.percentage));
        break;
      default:
        break;
    }
  }

  void _applyFilter() {
    switch (_filterOption) {
      case 'Pass':
        _filteredResults = _testResults.where((result) => result.shortRemark == 'PASS').toList();
        break;
      case 'Fail':
        _filteredResults = _testResults.where((result) => result.shortRemark == 'FAIL').toList();
        break;
      default:
        _filteredResults = _testResults;
        break;
    }
    _sortTestResults(); // Ensure sorting is applied after filtering
  }

  MaterialColor getColor(String text) {
    if (text == 'PASS') return Colors.green;
    else return Colors.red;
  }

  void _showFilterSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters & Sort',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Sort by:',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 8.0,
                children: ['Appeared on', 'Percentage'].map((String value) {
                  return ChoiceChip(
                    label: Text(value),
                    selected: _sortOption == value,
                    onSelected: (bool selected) {
                      setState(() {
                        _sortOption = value;
                        _sortTestResults();
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
              Divider(),
              Text(
                'Filter by:',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 8.0,
                children: ['All', 'Pass', 'Fail'].map((String value) {
                  return ChoiceChip(
                    label: Text(value),
                    selected: _filterOption == value,
                    onSelected: (bool selected) {
                      setState(() {
                        _filterOption = value;
                        _applyFilter();

                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // Reset filter and sort options to default
                        _sortOption = 'Appeared on';
                        _filterOption = 'All';
                        _applyFilter(); // Apply the default filter
                        _sortTestResults(); // Sort with the default option
                      });
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterSortBottomSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text('Failed to load data.'))
          : ListView.separated(
        itemCount: _filteredResults.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final testResult = _filteredResults[index];
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