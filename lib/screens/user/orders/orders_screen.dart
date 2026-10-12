import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/auth_provider.dart';
import 'package:printick/services/order_state_service.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:printick/screens/user/order/order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppAuthProvider>().user;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1BAF6),
              Color(0xFFEABFE9),
            ],
          ),
        ),
                         child: Row(
                  children: [
                    Text(
                      "Please log in to view your orders",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          
      ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1BAF6),
              Color(0xFFEABFE9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      "Your Orders",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: OrderStateService.streamActiveOrders(user.uid),
                  builder: (context, activeSnapshot) {

                if (activeSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
}

                    final activeOrders = activeSnapshot.data!;

                    return StreamBuilder<List<Map<String, dynamic>>>(
                      stream: OrderStateService.streamHistoryOrders(user.uid),
                      builder: (context, historySnapshot) {

                        if (!historySnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final historyOrders = historySnapshot.data!;

                        if (activeOrders.isEmpty && historyOrders.isEmpty) {
                          return _emptyState();
                        }

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [

                            /// ACTIVE
                            if (activeOrders.isNotEmpty) ...[
                              const Text(
                                "Active Orders",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              ...activeOrders.map((order) => _activeCard(order)).toList(),

                              const SizedBox(height: 20),
                            ],

                            /// HISTORY
                            if (historyOrders.isNotEmpty) ...[
                              const Text(
                                "Order History",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              ...historyOrders.map((order) => _historyCard(order)).toList(),
                            ],
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// EMPTY
  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 60, color: Colors.black38),
          SizedBox(height: 10),
          Text("No Orders Yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("Upload a document to get started"),
        ],
      ),
    );
  }

  /// 🔥 ACTIVE CARD (UPDATED)
  Widget _activeCard(Map<String, dynamic> order) {
    final token = order['token_number']?.toString() ?? "--";
    final createdAt = order['created_at'];
    final status = order['status'] ?? "pending";

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderScreen(orderId: order['id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOKEN
            Text(
              "$token",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            /// STATUS CHIP
     LayoutBuilder(
  builder: (context, constraints) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _orderProgress(status),

        FutureBuilder<Map<String, int>>(
          future: _getQueueAndTime(
            createdAt,
            order['page_count'],
            order['copies'],
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final queue = snapshot.data!['queue']!;
            final time = snapshot.data!['time']!;

            return _queueChip(queue, status, time);
          },
        ),
      ],
    );
  },
),

            const SizedBox(height: 8),

            /// TAP HINT
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  "Tap to view details",
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black45),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 HISTORY CARD
Widget _historyCard(Map<String, dynamic> order) {
  final token = order['token_number']?.toString() ?? "--";
  final pages = order['page_count'] ?? 0;
  final copies = order['copies'] ?? 0;
  final isColor = order['is_color'] ?? false;
  final price = order['price'] ?? 0;

  final rawDate = order['completed_at'] ?? order['created_at'];
  final date = DateTime.parse(rawDate);

final formattedDate =
    "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} '${date.year.toString().substring(2)}";

 return InkWell(
  borderRadius: BorderRadius.circular(18),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderScreen(
          orderId: order['id'],
        ),
      ),
    );
  },

  child: Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.6),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 6),
        )
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 LEFT SIDE (DETAILS)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TOKEN
              Text(
                "$token",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              /// STATUS
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "✅ Completed",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const SizedBox(height: 10),

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: const [

    Text(
      "Tap to view details",
      style: TextStyle(
        fontSize: 14,
        color: Colors.black45,
      ),
    ),

    SizedBox(width: 4),

    Icon(
      Icons.arrow_forward_ios,
      size: 12,
      color: Colors.black45,
    ),
  ],
),

            ],
          ),
        ),

        const SizedBox(width: 10),

        /// 🔥 RIGHT SIDE (PRICE + DATE)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            /// 💰 PRICE
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
              
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.15),
                    Colors.deepPurple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "₹$price",
                style: const TextStyle(
                  fontSize:16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 93, 41, 183),
                ),
              ),
            ),

            const SizedBox(height: 4),

            /// 📅 DATE
       /// 📅 DATE (MATCH PRICE STYLE)
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.blue.withOpacity(0.15),
        Colors.blue.withOpacity(0.05),
      ],
    ),
    borderRadius: BorderRadius.circular(14),
  ),
  child: Text(
    formattedDate,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
   color: Color(0xFF2563EB),  // modern blue
      fontSize: 12,
    ),
  ),
),
          ],
        ),
      ],
    ),
  ),
  );
}

  /// 🔥 QUEUE CHIP UI
 Widget _queueChip(int queue, String status, int time) {
  String mainText;
  String subText = "";

  if (status == "printing") {
    mainText = "🟢 Printing now";
  } else if (queue == 0) {
    mainText = "🟢 Your turn now 🥳";
  } else if (queue == 1) {
    mainText = "🟡 1 Person in Line";
    subText = "⏱ ~${time} min wait";
  } else {
    mainText = "🔴 $queue People in Line";
    subText = "⏱ ~${time} min wait";
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.08),
          Colors.black.withOpacity(0.03),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainText,
          style: const TextStyle(fontSize:16,fontWeight: FontWeight.bold),
        ),
        if (subText.isNotEmpty)
          Text(
            subText,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(249, 0, 0, 0),
            ),
          ),
      ],
    ),
  );
}
Widget _orderProgress(String status) {

  final bool isQueued =
      status == "pending" ||
      status == "printing" ||
      status == "completed";

  final bool isPrinting =
      status == "printing" ||
      status == "completed";

  final bool isCompleted =
      status == "completed";

  return Column(
    children: [

      /// 🔥 ICON LINE
      Row(
        children: [

          /// QUEUED
          _progressStep(
            icon: Icons.receipt_long_rounded,
            active: isQueued,
            color: const Color(0xFFFF9800),
          ),

          _progressLine(isPrinting),

          /// PRINTING
          _progressStep(
            icon: Icons.print_rounded,
            active: isPrinting,
            color: const Color(0xFF2196F3),
          ),

          _progressLine(isCompleted),

          /// COMPLETED
          _progressStep(
            icon: Icons.check_circle,
            active: isCompleted,
            color: const Color(0xFF4CAF50),
          ),
        ],
      ),

      const SizedBox(height: 8),

      /// 🔥 LABELS
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Queued",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            "Printing",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            "Completed",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );
}
Widget _progressStep({
  required IconData icon,
  required bool active,
  required Color color,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 38,
    width: 38,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: active
          ? LinearGradient(
              colors: [
                color.withOpacity(0.9),
                color,
              ],
            )
          : null,
      color: active ? null : Colors.white.withOpacity(0.7),
      boxShadow: active
          ? [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : [],
    ),
    child: Icon(
      icon,
      color: active ? Colors.white : Colors.grey,
      size: 18,
    ),
  );
}
Widget _progressLine(bool active) {
  return Expanded(
    child: Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: active
              ? [
                  const Color(0xFF7C4DFF),
                  const Color(0xFFB388FF),
                ]
              : [
                  const Color.fromARGB(255, 151, 148, 148),
                  Colors.grey.shade200,
                ],
        ),
      ),
    ),
  );
}
Future<Map<String, int>> _getQueueAndTime(
  String createdAt,
  int pages,
  int copies,
) async {
  final response = await SupabaseService.client
      .from('orders')
      .select('page_count, copies, is_color')
      .filter('status', 'in', '(pending,printing)')
      .lt('created_at', createdAt);

  int queue = response.length;

  int totalSeconds = 0;

  for (var item in response) {
    final int p = (item['page_count'] as num?)?.toInt() ?? 1;
    final int c = (item['copies'] as num?)?.toInt() ?? 1;
    final bool isColor = item['is_color'] ?? false;

    /// 🔥 TIME PER PAGE (SMART)
    final perPageTime = isColor ? 5 : 3; // seconds

    /// 🔥 BASE OVERHEAD (printer delay)
    final baseTime = 120; // seconds per order

    totalSeconds += (p * c * perPageTime) + baseTime;
  }

  /// 🔥 ADD SMALL BUFFER (real systems always do this)
  totalSeconds += 30;

  /// Convert to minutes (minimum 1)
  int minutes = (totalSeconds / 60).ceil();
  if (minutes == 0 && queue > 0) minutes = 1;

  return {
    'queue': queue,
    'time': minutes,
  };
}

String _monthName(int month) {
  const months = [
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];
  return months[month - 1];
}
}