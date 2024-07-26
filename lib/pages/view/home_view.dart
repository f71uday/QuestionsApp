import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/subjects.dart';
import '../quiz_page.dart';
import 'package:http/http.dart' as http;

Future<List<Subject>> fetchSubjects() async {
  final response = await http.get(Uri.parse('http://localhost/subjects'));

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body);
    final subjectsJson = parsed['_embedded']['subjects'] as List;
    return subjectsJson.map((json) => Subject.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load subjects');
  }
}

class HomeView extends StatefulWidget  {
  @override
  _HomeViewPage createState() => _HomeViewPage();

}

class _HomeViewPage extends State<HomeView> with AutomaticKeepAliveClientMixin
{
  late Future<List<Subject>> subjects;

  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<Subject>>(
        future: subjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final subject = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(5.0),
                  elevation: 1.0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject.name,
                          style: TextStyle(
                            fontSize: 20.0,

                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(questionLink: subject.questionsLink,subjectName: subject.name),
                              ),
                            );
                          },
                          child: Text('Start Quiz'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );

  }

  @override
  bool get wantKeepAlive => true;

}
