import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printick/models/notification_model.dart';

class NotificationCard extends StatelessWidget {

  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

IconData _getIcon() {

  switch (notification.type) {

    case 'order_update':

      switch (notification.orderStatus) {

        case 'completed':
          return Icons.check_circle_rounded;

        case 'printing':
          return Icons.print_rounded;

        case 'pending':
          return Icons.schedule_rounded;

        default:
          return Icons.notifications_rounded;
      }

    case 'printer_offline':
      return Icons.power_off_rounded;

    case 'printer_active':
      return Icons.power_rounded;

    case 'printer_maintenance':
      return Icons.build_rounded;

    default:
      return Icons.notifications_rounded;
  }
}

 Color _getColor() {

  switch (notification.type) {

    case 'order_update':

      switch (notification.orderStatus) {

        case 'completed':
          return Colors.green;

        case 'printing':
          return const Color.fromARGB(255, 187, 114, 4);

        case 'pending':
          return Colors.deepPurple;

        default:
          return Colors.blue;
      }

    case 'printer_offline':
      return Colors.red;

    case 'printer_active':
      return Colors.green;

    case 'printer_maintenance':
      return const Color.fromARGB(255, 197, 119, 3);

    default:
      return Colors.blue;
  }
}

  String _formatTime() {

    final now = DateTime.now();

    final difference =
        now.difference(notification.createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    return DateFormat('dd MMM').format(
      notification.createdAt,
    );
  }

  @override
  Widget build(BuildContext context) {

    final color = _getColor();

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 250,
        ),

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: notification.isRead
              ? Colors.white
              : const Color(0xFFEEF2FF),

          borderRadius:
              BorderRadius.circular(24),

          border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade200
                : const Color(0xFF6C63FF)
                
                    .withOpacity(0.18),
                width: notification.isRead ? 1 : 1.6,

          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// ICON
            Container(

              height: 58,
              width: 58,

              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.22),
                    color.withOpacity(0.08),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: Icon(
                _getIcon(),
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            /// CONTENT
            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      Expanded(

                        child: Text(

                          notification.title,

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        _formatTime(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(

                    notification.body,

                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(

  crossAxisAlignment:
      CrossAxisAlignment.center,

  children: [

    /// LEFT STATUS CHIP
    Expanded(

      child: Align(

        alignment: Alignment.centerLeft,

        child: Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),

          decoration: BoxDecoration(

            color:
                color.withOpacity(0.12),

            borderRadius:
                BorderRadius.circular(30),
          ),

          child: Text(

            notification.orderStatus
                    ?.toUpperCase() ??
                'ANNOUNCEMENT',

            overflow:
                TextOverflow.ellipsis,

            maxLines: 2,

            style: TextStyle(
              color: color,
              fontWeight:
                  FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    ),


    /// RIGHT FIXED SECTION
    if (!notification.isRead)
      Row(

        mainAxisSize: MainAxisSize.min,

        children: [
          const SizedBox(width: 10),

          Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),

            decoration: BoxDecoration(

              color: const Color(
                0xFF6C63FF,
              ).withOpacity(0.12),

              borderRadius:
                  BorderRadius.circular(30),
            ),

            child: const Text(

              'NEW',

              style: TextStyle(
                color:
                    Color(0xFF6C63FF),
                fontSize: 10,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(

            height: 10,
            width: 10,

            decoration:
                const BoxDecoration(

              color:
                  Color(0xFF6C63FF),

              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
  ],
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}