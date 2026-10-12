import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/auth_provider.dart';

class ProfileHeader extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onCameraTap;

  const ProfileHeader({
    super.key,
    required this.imageFile,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [

          /// 🔥 AVATAR WITH GRADIENT RING 
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (imageFile == null) return;

                  showDialog(
                    context: context,
                    builder: (_) => GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3), // ring thickness
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFB39DDB),
                        Color(0xFF9575CD),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFEDE7F6),
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile!) : null,
                    child: imageFile == null
                        ? const Icon(Icons.person,
                            size: 30, color: Colors.deepPurple)
                        : null,
                  ),
                ),
              ),

              /// 🔥 CAMERA BUTTON (CLEAN + MODERN)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          /// 🔥 USER INFO (SLIGHT TYPOGRAPHY IMPROVEMENT)
Expanded(
  child: Consumer<AppAuthProvider>(
    builder: (context, auth, child) {

      if (!auth.isProfileLoaded) {
        return const SizedBox(
  height: 20,
  child: LinearProgressIndicator(),
);
      }

      final fullName = auth.name ?? "User";
      final email = auth.email ?? "";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      );
    },
  ),
),
        ],
      ),
    );
  }

  /// 🔥 CARD WITH SOFT SHADOW
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}