import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/auth_provider.dart';
import 'package:printick/screens/user/profile/edit_field_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  final File? imageFile;

  const PersonalInfoScreen({super.key, this.imageFile});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Info"),
        centerTitle: true,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: auth.isProfileLoaded == false
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      /// 🔥 PROFILE IMAGE
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            imageFile != null ? FileImage(imageFile!) : null,
                        child: imageFile == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),

                      const SizedBox(height: 30),

                      /// 🔥 INFO CARD
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            /// 🔹 NAME
                            _buildTile(
                              icon: Icons.person,
                              title: "Full Name",
                              value: auth.name ?? "User",
                              onTap: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditFieldScreen(
                                      title: "Full Name",
                                      initialValue: auth.name ?? "",
                                    ),
                                  ),
                                );

                                if (updated != null && updated is String) {
                                  await context
                                      .read<AppAuthProvider>()
                                      .updateUserProfile(name: updated);
                                }
                              },
                            ),

                            /// 🔹 EMAIL
                            _buildTile(
                              icon: Icons.email,
                              title: "Email",
                              value: auth.email ?? "",
                              isLocked: true,
                            ),

                            /// 🔹 PHONE
                            _buildTile(
                              icon: Icons.phone,
                              title: "Phone Number",
                              value: auth.phone ?? "Add phone number",
                              onTap: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditFieldScreen(
                                      title: "Phone Number",
                                      initialValue: auth.phone ?? "",
                                    ),
                                  ),
                                );

                                if (updated != null && updated is String) {
                                 final success = await context
    .read<AppAuthProvider>()
    .updateUserProfile(phone: updated);

if (!success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Enter valid 10-digit Indian number"),
    ),
  );
}
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    bool isLocked = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(
            value,
            style: TextStyle(
              color: isLocked ? Colors.grey : Colors.black,
            ),
          ),
          trailing: isLocked
              ? const Icon(Icons.lock, size: 18)
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: isLocked ? null : onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}