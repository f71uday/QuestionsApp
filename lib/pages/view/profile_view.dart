import 'dart:convert';

import 'package:VetScholar/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../models/who_am_i.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  String _name = "Loading...";
  String _email = "Loading...";
  bool _isLoading = true;
  String _appVersion = "";
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _fetchProfileData() async {
   final response = await ProfileService().fetchProfileData();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userSession = UserSession.fromJson(data);

      setState(() {
        _name = '${userSession.identity?.traits?.name?.first ?? ''} ${userSession.identity?.traits?.name?.last ?? ''}';
        _email = userSession.identity?.traits?.email ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _name = 'Error loading name';
        _email = 'Error loading email';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    ProfileService().logout(context);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $_name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16), // Add space between email and list item
            ListTile(
              title: Text('Test History'),
              leading: Icon(Icons.history),
              onTap: () {
                // Navigate to the Test History page
                Navigator.pushNamed(context, '/testHistory');
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog();
                },
                child: Text('Logout'),
              ),
            ),
            Center(child: Text('Version: $_appVersion')),
          ],
        ),
      ),
    );
  }
}