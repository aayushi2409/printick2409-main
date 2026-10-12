import 'package:flutter/material.dart';

enum MessageType { success, error, warning, info }

class AppMessage {
  static void show(
    BuildContext context,
    String message, {
    MessageType type = MessageType.info,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    Color bgColor;
    IconData icon;

    switch (type) {
      case MessageType.success:
        bgColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case MessageType.error:
        bgColor = const Color.fromARGB(255, 179, 2, 2);
        icon = Icons.error;
        break;
      case MessageType.warning:
        bgColor = const Color.fromARGB(255, 179, 2, 2);
        icon = Icons.warning_amber_rounded;
        break;
      case MessageType.info:
      default:
        bgColor = Colors.blue;
        icon = Icons.info;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}