import 'package:VetScholar/service/subject_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/subjects.dart';
import '../quiz_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewPage createState() => _HomeViewPage();
}

class _HomeViewPage extends State<HomeView> with AutomaticKeepAliveClientMixin {
  late Future<List<Subject>> subjects;
  late SubjectService _subjectService;
  List<Subject> selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    _subjectService = SubjectService(context);
    subjects = _subjectService.fetchSubjects();
  }

  void _selectAll(bool isSelected, List<Subject> allSubjects) {
    setState(() {
      if (isSelected) {
        selectedSubjects = List.from(allSubjects);
      } else {
        selectedSubjects.clear();
      }
    });
  }

  void _toggleSubjectSelection(Subject subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }
  String _getSubjectIds(List<Subject> selectedSubjects) {
    return  selectedSubjects.map((subject) => subject.id).join(',');
  }

  @override
  Widget build(BuildContext context) {
    super
        .build(context); // Ensure AutomaticKeepAliveClientMixin works correctly
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedSubjects.isNotEmpty
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      questionLink: _getSubjectIds(selectedSubjects),
                      // Assuming you want the first subject's questions
                      subjectName: selectedSubjects.first.name,
                    ),
                  ),
                )
            : null, // Disable the button if no subject is selected
        label: Text('Start Quiz'),
        icon: Icon(Icons.play_arrow),
      ),
      appBar: AppBar(
        title: const Text('Subjects'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Subject>>(
        future: subjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final allSubjects = snapshot.data ?? [];

            return Column(
              children: [
                // Select All Checkbox
                CheckboxListTile(
                  title: const Text('Select All'),
                  value: selectedSubjects.length == allSubjects.length,
                  onChanged: (isSelected) =>
                      _selectAll(isSelected ?? false, allSubjects),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = allSubjects[index];
                      return Card(
                        margin: const EdgeInsets.all(5.0),
                        elevation: 1.0,
                        child: InkWell(
                          onTap: () => {
                            setState(() {
                              if (selectedSubjects.contains(subject)) {
                                selectedSubjects.remove(subject);
                              } else {
                                selectedSubjects.add(subject);
                              }
                            })
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: selectedSubjects.contains(subject),
                                  onChanged: (value) => _toggleSubjectSelection(subject),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    subject.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


}
