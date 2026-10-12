import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printick/screens/user/orders/orders_screen.dart';
import 'package:printick/services/supabase_service.dart';
import 'package:printick/screens/user/profile/help&support.dart';

class OrderScreen extends StatefulWidget {
  final String orderId;

  const OrderScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [

                    /// 🔥 BACK
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Ink(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Order Details",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔥 BODY
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: SupabaseService.client
                      .from('orders')
                      .stream(primaryKey: ['id'])
                      .eq('id', widget.orderId),

                  builder: (context, snapshot) {

                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final order = snapshot.data!.first;

                    final token =
                        order['token_number']?.toString() ?? "--";

                    final status =
                        order['status']?.toString() ?? "pending";

                    final pages =
                        order['page_count'] ?? 0;

                    final copies =
                        order['copies'] ?? 0;

                    final isColor =
                        order['is_color'] ?? false;

                    final fileName =
                        order['file_name'] ?? '';

                    final paper_size =
                        order['paper_size'] ?? 'A4';

                    final is_double_side =
                        order['is_double_side'] ?? false;

                    final price =
                        order['price'] ?? 0;

                    final paymentStatus =
                        order['payment_status'] ?? "paid";

                    final createdAt =
                        DateTime.parse(order['created_at'])
                            .toLocal();

                    final formattedDate = DateFormat(
                      "dd MMM yyyy • hh:mm a",
                    ).format(createdAt);

                    final completedAt =
                        order['completed_at'];

                    String completedDate = "";

                    final adminNote =
                      order['admin_note'] ?? '';

                    if (completedAt != null) {
                      completedDate = DateFormat(
                        "dd MMM yyyy • hh:mm a",
                      ).format(
                        DateTime.parse(completedAt)
                            .toLocal(),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [

                        /// 🔥 HERO CARD
                        _glassCard(
                          child: Column(
                            children: [

                              Row(
                                children: [

                                  /// ICON
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _statusColor(status)
                                              .withOpacity(0.18),

                                          _statusColor(status)
                                              .withOpacity(0.06),
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                    child: Icon(
                                      _statusIcon(status),
                                      color: _statusColor(status),
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  /// TEXT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          _statusText(status),
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                            color:
                                                _statusColor(status),
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          "Token • $token",
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (status != "completed")
                                    _liveBadge(),
                                ],
                              ),

                              const SizedBox(height: 22),

                              /// 🔥 MINI PROGRESS
                              _orderProgress(status),

                  
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔥 ORDER SUMMARY
                        _glassCard(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Order Summary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              _summaryRow(
                                "File Name",
                                fileName,
                              ),

                              _summaryRow(
                                "Pages",
                                "$pages",
                              ),

                              _summaryRow(
                                "Copies",
                                "$copies",
                              ),

                              _summaryRow(
                                "Print Type",
                                isColor
                                    ? "Color Print"
                                    : "Black & White",
                              ),

                       _summaryRow(
                        "Paper Size",
                       paper_size,
                                      ),

                      _summaryRow(
                         "Print Side",
                          is_double_side
                           ? "Double Side"
                            : "Single Side",
                                      ),
                     if (adminNote.isNotEmpty)
  _summaryRow(
    "Instructions",
    "' $adminNote '",
  ),

                              _summaryRow(
                                "Payment Status",
                                paymentStatus.toUpperCase(),
                                valueColor:
                                    const Color(0xFF16A34A),
                              ),
                              _summaryRow(
                                "Amount Paid",
                                "₹$price",
                                valueColor:
                                    const Color(0xFF6D28D9),
                              ),

                              _summaryRow(
                                "Ordered On",
                                formattedDate,
                              ),
                              if (status == "completed")
                                _summaryRow(
                                  "Completed On",
                                  completedDate,
                                  valueColor:
                                       Colors.black87,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔥 PICKUP INFO
                        _glassCard(
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange
                                          .withOpacity(0.15),

                                      Colors.orange
                                          .withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  color: Color.fromARGB(255, 155, 94, 3),
                                ),
                              ),

                              const SizedBox(width: 14),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Pickup Instructions",
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(
                                      "Collect your print from the library counter and show your token during pickup.",
                                      style: TextStyle(
                                        height: 1.45,
                                        color:
                                            Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔥 SUPPORT
                        InkWell(
                          borderRadius:
                              BorderRadius.circular(20),
                     onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const HelpSupportChatScreen(),
    ),
  );
},
                          child: _glassCard(
                            child: Row(
                              children: [

                                Container(
                                  padding:
                                      const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue
                                            .withOpacity(0.15),

                                        Colors.blue
                                            .withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                            14),
                                  ),
                                  child: const Icon(
                                    Icons.support_agent_rounded,
                                    color: Colors.blue,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [

                                      Text(
                                        "Need Help?",
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      Text(
                                        "Contact support regarding this order.",
                                        style: TextStyle(
                                          color:
                                              Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons
                                      .arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
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

  /// 🔥 GLASS CARD
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.58),
        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Colors.white.withOpacity(0.25),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  /// 🔥 SUMMARY ROW
  Widget _summaryRow(
    String title,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 MINI STEP PROGRESS
  Widget _orderProgress(String status) {

    final isQueued =
        status == "pending" ||
        status == "printing" ||
        status == "completed";

    final isPrinting =
        status == "printing" ||
        status == "completed";

    final isCompleted =
        status == "completed";

    return Column(
      children: [

        Row(
          children: [

            _progressStep(
              icon: Icons.receipt_long_rounded,
              active: isQueued,
              color: const Color.fromARGB(255, 206, 124, 2),
            ),

            _progressLine(isPrinting),

            _progressStep(
              icon: Icons.print_rounded,
              active: isPrinting,
              color: const Color(0xFF2563EB),
            ),

            _progressLine(isCompleted),

            _progressStep(
              icon: Icons.check_circle,
              active: isCompleted,
              color: const Color(0xFF16A34A),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
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

        color: active
            ? null
            : Colors.white.withOpacity(0.7),

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
        color:
            active ? Colors.white : Colors.grey,
        size: 18,
      ),
    );
  }

  Widget _progressLine(bool active) {
    return Expanded(
      child: Container(
        height: 4,
        margin:
            const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10),

          gradient: LinearGradient(
            colors: active
                ? [
                    const Color(0xFF7C4DFF),
                    const Color(0xFFB388FF),
                  ]
                : [
                    const Color.fromARGB(
                        255, 170, 170, 170),
                    Colors.grey.shade200,
                  ],
          ),
        ),
      ),
    );
  }

  /// 🔥 STATUS ICON
  IconData _statusIcon(String status) {
    switch (status) {

      case "printing":
        return Icons.print_rounded;

      case "completed":
        return Icons.check_circle_rounded;

      default:
        return Icons.schedule_rounded;
    }
  }

  /// 🔥 STATUS TEXT
  String _statusText(String status) {
    switch (status) {

      case "printing":
        return "Printing Now";

      case "completed":
        return "Ready for Pickup";

      default:
        return "Pending in Queue";
    }
  }

  /// 🔥 STATUS COLOR
  Color _statusColor(String status) {
    switch (status) {

      case "printing":
        return const Color(0xFF2563EB);

      case "completed":
        return const Color(0xFF16A34A);

      default:
        return const Color.fromARGB(255, 175, 107, 4);
    }
  }

  /// 🔥 LIVE BADGE
  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: const Text(
        "LIVE",
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}