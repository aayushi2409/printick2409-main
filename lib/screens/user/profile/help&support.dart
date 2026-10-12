import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportChatScreen extends StatefulWidget {
  const HelpSupportChatScreen({super.key});

  @override
  State<HelpSupportChatScreen> createState() =>
      _HelpSupportChatScreenState();
}
class _HelpSupportChatScreenState extends State<HelpSupportChatScreen> {
  List<Map<String, dynamic>> messages = [];
  
  @override
  void initState() {
    super.initState();
    _startChat();
  }

  /// 🔹 INITIAL BOT MESSAGE
  void _startChat() {
    messages.add({
      "text": "How can I help you today?",
      "isUser": false,
      "options": [
        "Issue with my order",
        "Payment problem",
        "File upload issue",
        "Print quality issue",
      ]
    });
  }

  /// 🔹 HANDLE USER SELECTION
  void _handleOptionTap(String option) {
    setState(() {
      // user message
      messages.add({"text": option, "isUser": true});

      // bot response
      messages.add(_getBotResponse(option));
    });
  }

  /// 🔹 BOT LOGIC
  Map<String, dynamic> _getBotResponse(String option) {
    switch (option) {
      case "Issue with my order":
        return {
          "text": "What issue are you facing?",
          "isUser": false,
          "options": [
            "Order not received",
            "Wrong print",
            "Order delayed"
          ]
        };

      case "Payment problem":
        return {
          "text":
              "If payment failed but amount deducted, it will be refunded within 24 hours.",
          "isUser": false,
          "options": ["Still need help"]
        };
        case "Still need help":
  return {
    "text": "You can contact our support team for further assistance.",
    "isUser": false,
    "options": ["Contact Support"]
  };

      case "File upload issue":
        return {
          "text":
              "Check your internet connection and upload PDF format for best results.",
          "isUser": false,
          "options": ["Still need help"]
        };
        case "Still need help":
  return {
    "text": "You can contact our support team for further assistance.",
    "isUser": false,
    "options": ["Contact Support"]
  };

      case "Print quality issue":
  return {
    "text": "Ensure your file resolution is clear before uploading.",
    "isUser": false,
    "options": ["Still need help"]   // 👈 add this
  };

case "Still need help":
  return {
    "text": "You can contact our support team for further assistance.",
    "isUser": false,
    "options": ["Contact Support"]
  };

      case "Order not received":
      case "Wrong print":
      case "Order delayed":
        return {
          "text":
              "Please contact the print shop or reach out to support for help.",
          "isUser": false,
          "options": ["Contact Support"]
        };

      case "Still need help":
        return {
          "text": "You can contact our support team for further assistance.",
          "isUser": false,
          "options": ["Contact Support"]
        };

      case "Contact Support":
        _sendEmail();
        return {
          "text": "Opening email support...",
          "isUser": false,
          "options": []
        };

      default:
        return {
          "text": "Please select an option.",
          "isUser": false,
          "options": []
        };
    }
  }

  /// 🔹 EMAIL FUNCTION
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'printick.support@gmail.com',
      queryParameters: {
        'subject': 'Help Needed',
        'body': 'Describe your issue here',
      },
    );

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  /// 🔹 CHAT BUBBLE
  Widget _buildMessage(Map<String, dynamic> msg) {
    return Align(
      alignment:
          msg["isUser"] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg["isUser"]
              ? Colors.deepPurple
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["text"],
          style: TextStyle(
            color: msg["isUser"] ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  /// 🔹 OPTIONS BUTTONS
  Widget _buildOptions(List options) {
    return Column(
      children: options.map<Widget>((opt) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              elevation: 0,
              side: const BorderSide(color: Colors.deepPurple),
            ),
            onPressed: () => _handleOptionTap(opt),
            child: Text(opt),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [

            /// 🔹 CHAT LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessage(msg),

                      if (msg["options"] != null &&
                          msg["options"].isNotEmpty)
                        _buildOptions(msg["options"]),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
