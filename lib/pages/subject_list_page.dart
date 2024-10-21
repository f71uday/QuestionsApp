import 'package:VetScholar/pages/test_history/test_history.dart';
import 'package:VetScholar/pages/view/home_view.dart';
import 'package:VetScholar/pages/view/profile_view.dart';
import 'package:flutter/material.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({Key? key}) : super(key: key);

  @override
  SubjectListPageState createState() => SubjectListPageState();
}

class SubjectListPageState extends State<SubjectListPage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  static const List<Widget> _pages = [
    HomeView(),
    TestHistoryPage(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final Color selectedColor = brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
    final Color unselectedColor = brightness == Brightness.light
        ? Colors.grey
        : Colors.grey.shade600;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      ),
    );
  }
}