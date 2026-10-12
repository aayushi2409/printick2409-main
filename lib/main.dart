import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:printick/providers/notification_provider.dart';

import 'package:printick/screens/user/home/home_screen.dart';
import 'package:printick/services/notification_local_service.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';

// Import screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/upload_provider.dart';

import 'package:printick/services/onesignal_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 ADD THIS LINE HERE
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationService.initialize();
  // await NotificationService.initialize();
  await OneSignalService.initialize();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Printick',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),

      // 👇 START SCREEN

    home : FirebaseAuth.instance.currentUser != null
        ? const HomeScreen()
        : const LoginScreen(),

      // 👇 ROUTES
      routes: {'/signup': (context) => const SignupScreen(),
      '/home': (context) => const HomeScreen(),},
    );
  }
}