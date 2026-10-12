import 'package:flutter/material.dart';
import 'package:printick/screens/user/order/order_screen.dart';
import 'package:marquee/marquee.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final String token;
  final int queue;
  final String status;
  final int pages;
  final int copies;
  final bool isColor;
  final String fileName;
  final String paperSize;
  final bool isDoubleSide;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.token,
    required this.queue,
    required this.status,
    required this.pages,
    required this.copies,
    required this.isColor,
    required this.fileName,
    required this.paperSize,
    required this.isDoubleSide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1BAF6),
              Color(0xFFEABFE9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔥 SUCCESS ICON
              Container(
                height: 100,
                width: 100,
           decoration: BoxDecoration(
  shape: BoxShape.circle,

  gradient: LinearGradient(
    colors: [
      Colors.white.withOpacity(0.95),
      Colors.white.withOpacity(0.75),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.green.withOpacity(0.18),
      blurRadius: 24,
      spreadRadius: 2,
      offset: const Offset(0, 10),
    ),
  ],
),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 56,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Order Placed Successfully🎉",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

            const SizedBox(height: 12),

Container(
  height: 38,
  margin: const EdgeInsets.symmetric(
    horizontal: 40,
  ),

  decoration: BoxDecoration(

    gradient: LinearGradient(
      colors: [
        Colors.white.withOpacity(0.72),
        Colors.white.withOpacity(0.45),
      ],
    ),

    borderRadius: BorderRadius.circular(30),

    border: Border.all(
      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
    ),

    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),

  child: ClipRRect(
    borderRadius: BorderRadius.circular(30),

    child: Marquee(

      text:
          "🔔 We'll notify you when Ready • Raho Bindaas ☺️ •",

      velocity: 50,

      blankSpace: 50,

      startPadding: 16,

      accelerationDuration:
          const Duration(seconds: 1),

      decelerationDuration:
          const Duration(milliseconds: 500),

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  ),
),

              const SizedBox(height: 30),

              /// 🔥 TOKEN (MAIN HIGHLIGHT)
              Center(
  child: ConstrainedBox(

    constraints: const BoxConstraints(
      maxWidth: 310,
    ),

    child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
            decoration: BoxDecoration(

  gradient: const LinearGradient(
    colors: [
      Color.fromARGB(255, 23, 23, 23),
      Color.fromARGB(255, 13, 13, 13),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  borderRadius: BorderRadius.circular(34),

  border: Border.all(
    color: Colors.white.withOpacity(0.08),
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ],
),
                child: Column(
                  children: [
                    const Text(
                      "Your Token:",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      token.isEmpty ? "--" : token,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

TweenAnimationBuilder<double>(

  tween: Tween(begin: 0.97, end: 1.02),

  duration: const Duration(seconds: 2),

  curve: Curves.easeInOut,

  builder: (context, scale, child) {

    return Transform.scale(
      scale: scale,
      child: child,
    );
  },



  child: Container(

    height: 38,

    margin: const EdgeInsets.symmetric(
      horizontal: 25,
    ),

    decoration: BoxDecoration(

      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.75),
          Colors.white.withOpacity(0.45),
        ],
      ),

      borderRadius: BorderRadius.circular(30),

      boxShadow: [
        BoxShadow(
          color: Colors.deepPurple.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),

    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),

      child: Marquee(

        text:
            "• 🎟️ Show this token at pickup ",

        velocity: 35,

        blankSpace: 40,

        startPadding: 12,

        pauseAfterRound:
            const Duration(seconds: 1),

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ),
  ),
),
                  ],
                ),
              ),
  ),
              ),
              const SizedBox(height: 35),

             /// 🔥 BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    /// TRACK ORDER
                    ElevatedButton(
 onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => OrderScreen(
  orderId: orderId,
)
    ),
  );
},
                      style: ElevatedButton.styleFrom(
backgroundColor:  Color(0xFF9D7BFF),
foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                  child: Ink(
  decoration: BoxDecoration(

    gradient: const LinearGradient(
      colors: [
        Color.fromARGB(255, 160, 143, 247),
        Color.fromARGB(255, 141, 107, 245),
      ],
    ),

    borderRadius: BorderRadius.circular(14),
  ),

  child: Container(
    alignment: Alignment.center,
    height: 50,

    child: const Text(
      "Track Order",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
                    ),

                    const SizedBox(height: 10),

                    /// HOME
                    OutlinedButton(

                    onPressed: () {
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/home',
    (route) => false,
  );
},
                      style: OutlinedButton.styleFrom(

  backgroundColor:
      Colors.white.withOpacity(0.55),

  side: BorderSide(
    color: Colors.white.withOpacity(0.5),
  ),

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),

  minimumSize:
      const Size(double.infinity, 50),
),
                     child: const Text(
  "Go Home",
  style: TextStyle(
    color: Color(0xFF5B4CB2),
    fontWeight: FontWeight.w600,
  ),
),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 ROW
 Widget _row(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Expanded(
          flex: 4,
          child: Text(title),
        ),

        /// VALUE
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

}