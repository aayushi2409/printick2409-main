import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printick/screens/user/profile/widgets/profile_header.dart';
import 'widgets/stats_row.dart';
import 'widgets/profile_tile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'personal_info.dart';
import 'package:printick/screens/auth/login_screen.dart';
import 'package:printick/screens/user/profile/privacy_security.dart';
import 'package:printick/screens/user/profile/help&support.dart';
import 'package:printick/screens/user/profile/notification.dart';
import 'package:printick/screens/user/profile/settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  /// ✅ LOAD IMAGE ON APP START
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString("profile_image");

    if (path != null && File(path).existsSync()) {
      setState(() {
        _imageFile = File(path);
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imageFile = null;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
  }

  /// ✅ SHOW CAMERA / GALLERY OPTIONS
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              /// 🔴 REMOVE PHOTO OPTION
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    "Remove Photo",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ PICK + SAVE IMAGE
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔝 HEADER
              ProfileHeader(
                imageFile: _imageFile,
                onCameraTap: _showImageOptions,
              ),

              const SizedBox(height: 12),

              /// 📊 STATS
              const StatsRow(),

              const SizedBox(height: 20),

              /// ACCOUNT TITLE
              const Text(
                "Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 10),

              /// ACCOUNT CARD
              Container(
                decoration: _cardDecoration(),
                child: Column(
                  children: [

                    ProfileTile(
                      Icons.person,
                      "Personal Info",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PersonalInfoScreen(
                              imageFile: _imageFile,
                            ),
                          ),
                        );
                      },
                    ),

                    ProfileTile(
                      Icons.security,
                      "Privacy & Security",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacySecurityScreen(),
                          ),
                        );
                      },
                    ),

                    
                    ProfileTile(
  Icons.notifications,
  "Notifications",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  },
),
                    ProfileTile(
  Icons.settings,
  "Settings",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  },
),
                    ProfileTile(
  Icons.help_outline,
  "Help & Support",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpSupportChatScreen(),
      ),
    );
  },
),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// LOGOUT
              Container(
                decoration: _cardDecoration(),
                child: ProfileTile(
                  Icons.logout,
                  "Log Out",
                  isLogout: true,
                  onTap: () {
                    _handleLogout(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

/// 🔥 LOGOUT FUNCTION
void _handleLogout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );
}