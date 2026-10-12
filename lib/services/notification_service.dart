import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/models/notification_model.dart';
import 'package:printick/services/supabase_service.dart';

class NotificationService {

  static final _client =
      SupabaseService.client;

  static Future<List<NotificationModel>>
      fetchNotifications() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return [];

    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', user.uid)
        .order(
          'created_at',
          ascending: false,
        );

    return response
        .map<NotificationModel>(
          (e) => NotificationModel
              .fromMap(e),
        )
        .toList();
  }

  static Stream<List<NotificationModel>>
      realtimeNotifications() {

    final user =
        FirebaseAuth.instance.currentUser;

    return _client
        .from('notifications')
        .stream(
          primaryKey: ['id'],
        )
        .eq('user_id', user!.uid)
        .order(
          'created_at',
          ascending: false,
        )
        .map(
          (data) => data
              .map(
                (e) =>
                    NotificationModel
                        .fromMap(e),
              )
              .toList(),
        );
  }

  static Future<void>
      markAsRead(String id) async {

    await _client
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq('id', id);
  }

  static Future<void>
      markAllAsRead() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _client
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq('user_id', user.uid)
        .eq('is_read', false);
  }
}