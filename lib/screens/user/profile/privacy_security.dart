import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/screens/auth/login_screen.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy & Security"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
            child: Align( // 🔥 ADD THIS
            alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showChangePasswordSheet(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  /// 🔐 CHANGE PASSWORD
  void _showChangePasswordSheet(BuildContext context) {
    final current = TextEditingController();
    final newPass = TextEditingController();
    final confirm = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _field(current, "Current Password"),
              const SizedBox(height: 12),
              _field(newPass, "New Password"),
              const SizedBox(height: 12),
              _field(confirm, "Confirm Password"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (current.text.isEmpty ||
                        newPass.text.isEmpty ||
                        confirm.text.isEmpty) {
                      _snack(context, "All fields required");
                      return;
                    }

                    if (newPass.text != confirm.text) {
                      _snack(context, "Passwords do not match");
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;

                    try {
                      // 🔐 RE-AUTH
                      final credential =
                          EmailAuthProvider.credential(
                        email: user!.email!,
                        password: current.text,
                      );

                      await user.reauthenticateWithCredential(credential);

                      // 🔐 UPDATE PASSWORD
                      await user.updatePassword(newPass.text);

                      Navigator.pop(context);
                      _snack(context, "Password updated");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        _snack(context, "Wrong current password");
                      } else if (e.code == 'requires-recent-login') {
                        _snack(context, "Please login again");
                      } else {
                        _snack(context, e.message ?? "Error");
                      }
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔴 DELETE ACCOUNT
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Delete Account"),
          content: const Text(
              "This action cannot be undone. Continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final user = FirebaseAuth.instance.currentUser;

                try {
                  await user?.delete();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  _snack(context, "Please login again");
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}