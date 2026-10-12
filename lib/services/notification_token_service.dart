import 'package:firebase_auth/firebase_auth.dart';
// import 'package:printick/services/notification_service.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationTokenService {

  static Future<void> saveToken() async {

  try {

    print("🔥 SAVE ONESIGNAL ID STARTED");

    final user =
        FirebaseAuth.instance.currentUser;

    print("🔥 USER => ${user?.uid}");

    if (user == null) return;

    /// 🔥 GET ONESIGNAL ID
    final oneSignalId =
        OneSignal.User.pushSubscription.id;

    print(
      "🔥 ONESIGNAL ID => $oneSignalId",
    );

    if (oneSignalId == null) return;

    /// 🔥 SAVE TO SUPABASE
    final response =
        await SupabaseService.client
            .from('profiles')
            .update({
              'onesignal_id': oneSignalId,
            })
            .eq('user_id', user.uid)
            .select();

    print(
      "🔥 SUPABASE RESPONSE => $response",
    );

    print(
      "🔥 ONESIGNAL ID SAVED",
    );

  } catch (e) {

    print(
      "🔥 SAVE ERROR => $e",
    );
  }
}

}