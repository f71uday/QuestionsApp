import 'package:VetScholar/service/subject_service.dart';
import 'package:flutter/material.dart';
import '../../models/subjects.dart';
import '../quiz_page.dart';

// HomeView StatefulWidget
class HomeView extends StatefulWidget {
  @override
  _HomeViewPage createState() => _HomeViewPage();
}

class _HomeViewPage extends State<HomeView> with AutomaticKeepAliveClientMixin {
  late Future<List<Subject>> subjects;
  SubjectService _subjectService = SubjectService();

  @override
  void initState() {
    super.initState();
    subjects = _subjectService.fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    super
        .build(context); // Ensure AutomaticKeepAliveClientMixin works correctly
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: FutureBuilder<List<Subject>>(
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
                        Flexible(
                          child: Text(
                            subject.name,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  questionLink: subject.questionsLink,
                                  subjectName: subject.name,
                                ),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
