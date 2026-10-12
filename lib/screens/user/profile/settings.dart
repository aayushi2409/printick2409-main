import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),

            /// 🔥 SMALL CLEAN CARD ONLY
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
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

                      /// 🔹 ABOUT APP
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("About App"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutScreen(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      /// 🔹 TERMS & PRIVACY
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text("Terms & Privacy"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsScreen(),
                            ),
                          );
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
}

////////////////////////////////////////////////////////////
/// 📄 ABOUT SCREEN
////////////////////////////////////////////////////////////

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("About App"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  /// 🔹 APP NAME
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Printick",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Version 1.0.0"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  /// 🔹 ABOUT
                  Text(
                    "About the App",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Printick allows students to upload and print documents easily from their phone, making printing simple and convenient.",
                  ),

                  SizedBox(height: 16),

                  /// 🔹 FEATURES
                  Text(
                    "Features",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text("• Upload PDF files easily"),
                  Text("• Select number of copies"),
                  Text("• Choose color or black & white"),
                  Text("• Track print orders"),
                  Text("• Simple and user-friendly interface"),
                
                SizedBox(height: 24),

Center(
  child: Text(
    "© 2026 Printick. All rights reserved.",
    style: TextStyle(
      fontSize: 12,
      color: Colors.black45,
    ),
    textAlign: TextAlign.center,
  ),
),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 📜 TERMS SCREEN
////////////////////////////////////////////////////////////

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Terms & Privacy"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔐 TERMS
                  Text(
                    "Terms of Service",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Text("• This app is intended for academic use only"),
                  Text("• Users must upload valid and appropriate files"),
                  Text("• The app is not responsible for incorrect print selections"),
                  Text("• Users are responsible for reviewing files before printing"),
                  Text(
                    "• Misuse of the app, including uploading inappropriate or irrelevant content, may result in restricted or blocked access",
                  ),

                  SizedBox(height: 16),

                  /// 🔒 PRIVACY
                  Text(
                    "Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  Text("• We collect basic user information such as name and email"),
                  Text("• Uploaded files are used only for printing purposes"),
                  Text("• We do not share user data with third parties"),
                  Text("• Your data is handled securely"),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}