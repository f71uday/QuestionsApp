import 'dart:convert';

import 'package:VetScholar/pages/view/home_view.dart';
import 'package:VetScholar/pages/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/subjects.dart';

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

class SubjectListPage extends StatefulWidget {
  @override
  _SubjectListPageState createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late Future<List<Subject>> subjects;
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  static  List<Widget> _pages = <Widget>[
    HomeView(),
    //SearchView(),
    ProfileView(),
  ];
  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}