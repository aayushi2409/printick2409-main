import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin
      notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel
      channel =
      AndroidNotificationChannel(

    'printick_channel',

    'Printick Notifications',

    description:
        'Order updates and alerts',

    importance: Importance.max,

    playSound: true,

    enableVibration: true,
  );

  static Future<void> initialize() async {

    /// ANDROID INIT
    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings,
    );

    /// CREATE CHANNEL
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          channel,
        );
  }

  static Future<void> show({

    required String title,

    required String body,

  }) async {

    const androidDetails =
        AndroidNotificationDetails(

      'printick_channel',

      'Printick Notifications',

      channelDescription:
          'Order updates and alerts',

      importance: Importance.max,

      priority: Priority.high,

      playSound: true,

      enableVibration: true,
    );

    const details =
        NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      0,
      title,
      body,
      details,
    );
  }
}