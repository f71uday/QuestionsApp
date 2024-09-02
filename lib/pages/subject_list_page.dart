import 'package:VetScholar/pages/test_history/test_history.dart';
import 'package:VetScholar/pages/view/home_view.dart';
import 'package:VetScholar/pages/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../models/subjects.dart';

class SubjectListPage extends StatefulWidget {
  @override
  _SubjectListPageState createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late Future<List<Subject>> subjects;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  static final List<Widget> _pages = <Widget>[
    HomeView(),
    TestHistoryPage(),
    ProfileView()
  ];

  @override
  void initState() {
    super.initState();
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: _selectedIndex,
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
