import 'dart:convert';

import 'package:VetScholar/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme_provider.dart';
import '../../models/who_am_i.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  String _name = "Loading...";
  String _email = "Loading...";
  bool _isLoading = true;
  String _appVersion = "1.0.0";
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _getAppVersionAndMode();
  }

  Future<void> _getAppVersionAndMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _isDarkMode = prefs.getBool(dotenv.env["IS_MODE_DARK"]!)!;
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _fetchProfileData() async {
    final response = await ProfileService().fetchProfileData();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userSession = UserSession.fromJson(data);

      setState(() {
        _name =
            '${userSession.identity?.traits?.name?.first ?? ''} ${userSession.identity?.traits?.name?.last ?? ''}';
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text("Settings"),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(_isDarkMode
                            ? Icons.mode_night_outlined
                            : Icons.nightlight),
                        const Text('Dark Mode'),
                        Switch(
                          value: _isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                            setState(() {
                              _isDarkMode = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: FilledButton.tonal(
                      onPressed: () {
                        _showLogoutDialog();
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  Center(child: Text('Version: $_appVersion')),
                ],
              ),
      ),
    );
  }

}
