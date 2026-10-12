import 'dart:convert';

import 'package:http/http.dart'
    as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminNotificationService {
  static String get appId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';
  static String get apiKey => dotenv.env['ONESIGNAL_API_KEY'] ?? '';

  static Future<void> sendToUser({

    required String oneSignalId,

    required String title,

    required String message,

  }) async {

    try {

      final response =
          await http.post(

        Uri.parse(
          'https://api.onesignal.com/notifications',
        ),

        headers: {

          "accept": "application/json",

          "content-type":
              "application/json",

          "Authorization":
              "Key $apiKey",
        },

        body: jsonEncode({

          "app_id": appId,

          "include_subscription_ids": [
            oneSignalId,
          ],

          "headings": {
            "en": title,
          },

          "contents": {
            "en": message,
          },

          "target_channel": "push",
        }),
      );

      print(
        "🔥 STATUS => ${response.statusCode}",
      );

      print(
        "🔥 RESPONSE => ${response.body}",
      );

    } catch (e) {

      print(
        "❌ ERROR => $e",
      );
    }
  }
}