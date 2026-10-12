import 'dart:async';

import 'package:flutter/material.dart';
import 'package:printick/models/notification_model.dart';
import 'package:printick/services/notification_service.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NotificationProvider
    extends ChangeNotifier {

  List<NotificationModel>
      notifications = [];

  bool isLoading = false;

  StreamSubscription?
      _subscription;

  int get unreadCount =>
      notifications
          .where(
            (e) => !e.isRead,
          )
          .length;

  Future<void> initialize() async {

    isLoading = true;

    notifyListeners();

    notifications = await
        NotificationService
            .fetchNotifications();

    isLoading = false;

    notifyListeners();

    _listenRealtime();
  }

  void _listenRealtime() {

    _subscription?.cancel();

    _subscription =
        NotificationService
            .realtimeNotifications()
            .listen((data) {

      notifications = data;

      notifyListeners();
    });
  }

Future<void> markAsRead(
  String id,
) async {

  await NotificationService
      .markAsRead(id);

  final index = notifications.indexWhere(
    (e) => e.id == id,
  );

  if (index != -1) {

    notifications[index] =
        NotificationModel(

      id: notifications[index].id,
      userId:
          notifications[index].userId,
      title:
          notifications[index].title,
      body:
          notifications[index].body,
      type:
          notifications[index].type,
      isRead: true,
      isSent:
          notifications[index].isSent,
      createdAt:
          notifications[index].createdAt,
      orderId:
          notifications[index].orderId,
      imageUrl:
          notifications[index].imageUrl,
      deepLink:
          notifications[index].deepLink,
      actionType:
          notifications[index].actionType,
      priority:
          notifications[index].priority,
      orderStatus:
          notifications[index]
              .orderStatus,
    );

    notifyListeners();
  }
}

 Future<void> deleteNotification(
  String id,
) async {

  try {

    await SupabaseService.client
        .from('notifications')
        .delete()
        .eq('id', id);

    notifications.removeWhere(
      (item) => item.id == id,
    );

    notifyListeners();

  } catch (e) {

    debugPrint(
      "DELETE ERROR => $e",
    );
  }
}
Future<void> deleteAllNotifications() async {

  try {

    await SupabaseService.client
        .from('notifications')
        .delete()
.eq(
  'user_id',
  FirebaseAuth.instance.currentUser!.uid,
);
    notifications.clear();

    notifyListeners();

  } catch (e) {

    debugPrint(
      "DELETE ALL ERROR => $e",
    );
  }
}
Future<void>
    markAllAsRead() async {

  await NotificationService
      .markAllAsRead();

  notifications = notifications
      .map(
        (e) => NotificationModel(

          id: e.id,
          userId: e.userId,
          title: e.title,
          body: e.body,
          type: e.type,
          isRead: true,
          isSent: e.isSent,
          createdAt: e.createdAt,
          orderId: e.orderId,
          imageUrl: e.imageUrl,
          deepLink: e.deepLink,
          actionType: e.actionType,
          priority: e.priority,
          orderStatus: e.orderStatus,
        ),
      )
      .toList();

  notifyListeners();
}
  @override
  void dispose() {

    _subscription?.cancel();

    super.dispose();
  }

  
}