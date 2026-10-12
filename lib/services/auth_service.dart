import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/services/notification_token_service.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔐 SIGNUP METHOD
  Future<String?> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      /// 🔹 Normalize input
      final String cleanEmail = email.trim().toLowerCase();
      final String cleanPassword = password.trim();
      final cleanUsername = username.trim().toLowerCase();

      /// 🔹 Validation
      if (cleanUsername.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
        return "Please fill all fields";
      }

      if (!cleanEmail.endsWith("@medicaps.ac.in")) {
        return "Use your college email (@medicaps.ac.in)";
      }

      if (cleanPassword.length < 6) {
        return "Password must be at least 6 characters";
      }

      /// 🔥 Create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPassword,
      );

      final user = userCredential.user!;
      /// 🔥 STORE USER IN SUPABASE
      await SupabaseService.client.from('profiles').upsert({
        "user_id": user.uid,
        "email": cleanEmail,
        "user_name": cleanUsername,
        "role": "user",
      });


      /// 🔥 Send verification email
      await userCredential.user?.sendEmailVerification();

      /// 🔥 Sign out (important for flow)
      await _auth.signOut();

      return "Verification email sent. Please check your Spam folder.";
    }

    /// 🔥 Firebase errors
    on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "Email already registered🥲!\nPlease login to your account or use a different email";
        case 'invalid-email':
          return "Invalid email format";
        case 'weak-password':
          return "Password is too weak";
        default:
          return "Something went wrong";
      }
    } catch (e) {
      return "Unexpected error occurred";
    }
  }
   
   //Login methods🔐
  Future<String?> login({
  required String email,
  required String password,
}) async {
  try {
    final String cleanEmail = email.trim().toLowerCase();
    final String cleanPassword = password.trim();

    /// 🔹 Validation
    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return "Please fill all fields";
    }

    if (!cleanEmail.endsWith("@medicaps.ac.in")) {
      return "Use your college email (@medicaps.ac.in)";
    }

    /// 🔥 Firebase login
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: cleanPassword,
    );

    final user = userCredential.user;

    /// 🔴 Check verification
    if (user != null && !user.emailVerified) {
      await _auth.signOut();
      return "Please verify your email before log in🔓\nCheck Spam folder📧";
    }
     /// 🔥 LINK USER WITH ONESIGNAL
OneSignal.login(user!.uid);

print(
  "🔥 ONESIGNAL LOGIN => ${user.uid}",
);
    await NotificationTokenService.saveToken();
    return "Login successful";
  }

  on FirebaseAuthException catch (e) {
  switch (e.code) {
  case 'user-not-found':
    return "Account not found. Please create an account first.";

  case 'wrong-password':
    return "Incorrect password. Try again.";

  case 'invalid-email':
    return "Invalid email format";

  case 'invalid-credential':
    return "Invalid email or password!\nIf you don't have an account\nPlease create one.";

  default:
    return "Login failed. Please try again.";
}
  } catch (e) {
    return "Unexpected error occurred";
  }
}

}