class NotificationModel {

  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final bool isSent;
  final String? orderId;
  final String? imageUrl;
  final String? deepLink;
  final String? actionType;
  final String? priority;
  final String? orderStatus;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.isSent,
    required this.createdAt,
    this.orderId,
    this.imageUrl,
    this.deepLink,
    this.actionType,
    this.priority,
    this.orderStatus,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return NotificationModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      body: map['body'],
      type: map['type'] ?? 'general',
      isRead: map['is_read'] ?? false,
      isSent: map['is_sent'] ?? false,
      orderId: map['order_id'],
      imageUrl: map['image_url'],
      deepLink: map['deep_link'],
      actionType: map['action_type'],
      priority: map['priority'],
      orderStatus: map['order_status'],
      createdAt: DateTime.parse(
        map['created_at'],
      ),
    );
  }
}