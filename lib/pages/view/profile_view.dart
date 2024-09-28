import 'dart:io';
import 'dart:convert';

import 'package:VetScholar/pages/bookmarked_questions.dart';
import 'package:VetScholar/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart'; // Add this import
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme_provider.dart';
import '../../models/who_am_i.dart';
import '../error/no_internet.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String _name = "Loading...";
  String _email = "Loading...";
  bool _isLoading = true;
  String _appVersion = "1.0.0";
  bool _isDarkMode = false;
  bool _hasError = true;
  File? _imageFile; // For storing the picked image

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

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
    try {
      final response = await ProfileService().fetchProfileData();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userSession = UserSession.fromJson(data);

        setState(() {
          _name =
              '${userSession.identity?.traits?.name?.first ?? ''} ${userSession.identity?.traits?.name?.last ?? ''}';
          _email = userSession.identity?.traits?.email ?? '';
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _name = 'Error loading name';
          _email = 'Error loading email';
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (_) {
      setState(() {
        _hasError = true;
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

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
                ? NoInternetPage(
                    onRetry: () {
                      setState(() {
                        _isLoading = true;
                        _hasError = false;
                      });
                      _fetchProfileData();
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // Trigger image picking on tap
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                                ) as ImageProvider, // Show picked image or default image
                          child: const Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 18,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        style: const TextStyle(fontSize: 16),
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(_isDarkMode
                                ? Icons.mode_night_outlined
                                : Icons.sunny),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text('Dark Mode'),
                            const Spacer(),
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
                      const Row(
                        children: [
                          Text("Personal"),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const BookmarkedQuestionsPage())),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.bookmark),
                              SizedBox(
                                width: 16,
                              ),
                              Text('Bookmarks'),
                              Spacer(),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: FilledButton.tonal(
                          onPressed: _showLogoutDialog,
                          child: const Text('Logout'),
                        ),
                      ),
                      Center(child: Text('Version: $_appVersion')),
                    ],
                  ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
