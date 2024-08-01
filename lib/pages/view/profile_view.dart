import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

import '../../models/who_am_i.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  String _name = "Loading...";
  String _email = "Loading...";
  bool _isLoading = true;
  String baseurl = '127.0.0.1:4433';
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
    String? sessionToken = await secureStorage.read(key: 'session_token');
    final url = Uri.http(baseurl, '/sessions/whoami');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $sessionToken',
      },
    );

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
    String? sessionToken = await secureStorage.read(key: 'session_token');
    final url = Uri.http(baseurl, '/sessions');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $sessionToken',
      },
      body: json.encode({
        'session_token': sessionToken,
      }),
    );

    if (response.statusCode == 200) {
      await secureStorage.delete(key: 'session_token');
      Navigator.of(context).pushReplacementNamed('/signin'); // Replace with your login route
    } else {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout')),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
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
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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