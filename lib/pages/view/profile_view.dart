import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../auth_page.dart';


class ProfileView extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  Map<String, dynamic>? _userInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await AuthService.getUserInfo();
      setState(() {
        _userInfo = userInfo;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error loading user info: $e');
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _userInfo == null
          ? Center(child: Text('No user info available'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_userInfo?['name'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${_userInfo?['email'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('ID: ${_userInfo?['id'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            // Add more user info fields if available
          ],
        ),
      ),
    );
  }
}