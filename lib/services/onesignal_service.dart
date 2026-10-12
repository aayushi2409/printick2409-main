import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:printick/services/notification_local_service.dart';
class OneSignalService {

  static Future<void> initialize() async {

    /// DEBUG LOGS
    OneSignal.Debug.setLogLevel(
      OSLogLevel.verbose,
    );

    /// INITIALIZE
    OneSignal.initialize(
      "889662fc-f777-4a11-b8ab-4cad19dae5a1",
    );
    await OneSignal.Notifications
    .requestPermission(true);

    /// REQUEST PERMISSION
OneSignal.Notifications
    .addForegroundWillDisplayListener(

  (event) async {

    event.preventDefault();

    await LocalNotificationService.show(

      title:
          event.notification.title ??
          "Notification",

      body:
          event.notification.body ??
          "",
    );
  },
);
        

    /// GET PLAYER ID
    final playerId =
        OneSignal.User.pushSubscription.id;

    print(
      "🔥 ONESIGNAL PLAYER ID => $playerId",
    );
  }
}