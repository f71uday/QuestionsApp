import 'package:VetScholar/service/test_history_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Remark.dart';
import '../models/test_result.dart';

class TestHistoryPage extends StatefulWidget {
  TestHistoryPage({super.key});

  @override
  TestHistoryPageState createState() => TestHistoryPageState();
}

class TestHistoryPageState extends State<TestHistoryPage> {
  late List<TestResult> _testResults = [];
  late List<TestResult> _filteredResults = [];
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

  void _disableLoadWithError() {
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }

  void _disableLoadWithSuccess(List<TestResult> testResults) {
    setState(() {
      _testResults = testResults;
      _applyFilter(); // Apply filter after fetching data
      _sortTestResults(); // Sort after filtering
      _isLoading = false;
    });
  }

  Future<void> _fetchTestHistory() async {
    try {
      TestHistoryServices services = TestHistoryServices(context);
      _disableLoadWithSuccess(await services.fetchHistory());
    } catch (error) {
      _disableLoadWithError();
    } finally {
      // _disableLoadWithError();
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
        _filteredResults = _testResults
            .where((result) => result.remark == Remark.PASS)
            .toList();
        break;
      case 'Fail':
        _filteredResults = _testResults
            .where((result) => result.remark == Remark.FAIL)
            .toList();
        break;
      default:
        _filteredResults = _testResults;
        break;
    }

    _sortTestResults();
  }

  MaterialColor _getColor(Remark remark) {
    return remark == Remark.PASS ? Colors.green : Colors.red;
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      title: Text(
                        testResult.testName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Score: ${testResult.correctAnswers} / ${testResult.totalQuestions}'),
                          Text(
                              'Appeared on: ${formatter.format(testResult.createdAt.toLocal())}'),
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
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _getColor(testResult.remark)),
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
