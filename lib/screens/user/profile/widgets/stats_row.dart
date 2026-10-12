import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printick/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    /// 🔥 LOADING STATE
    if (!auth.isStatsLoaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// 🔥 FORMAT LAST ORDER DATE
    String lastOrderText = "No orders";
    if (auth.lastOrderDate != null) {
      try {
        final date = DateTime.parse(auth.lastOrderDate!);
        lastOrderText = DateFormat('dd MMM yy').format(date);
      } catch (_) {
        lastOrderText = "Invalid date";
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: _cardDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          /// 🔹 TOTAL ORDERS
          _StatItem(
            Icons.description,
            auth.totalOrders.toString(),
            "Orders Done",
          ),

          const _Divider(),

          /// 🔹 TOTAL SPENT
          _StatItem(
            Icons.account_balance_wallet,
            "₹${auth.totalSpent.toStringAsFixed(0)}",
            "Total Spent",
          ),

          const _Divider(),

          /// 🔹 LAST ORDER
          _StatItem(
            Icons.access_time,
            lastOrderText,
            "Last Order",
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        ),
      ],
    );
  }
}

/// ===============================
/// 🔹 STAT ITEM
/// ===============================
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// 🔹 DIVIDER
/// ===============================
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.black12,
    );
  }
}