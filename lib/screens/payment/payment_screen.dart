import 'package:flutter/material.dart';
import 'package:printick/models/price_breakdown_model.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  bool isProcessing = false;


  final methods = [
    {"name": "Google Pay", "icon": Icons.account_balance_wallet},
    {"name": "PhonePe", "icon": Icons.phone_android},
    {"name": "Paytm", "icon": Icons.payment},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Payment")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🔹 AMOUNT
          Text(
            "Pay ₹${widget.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// 🔹 PAYMENT OPTIONS
          Expanded(
            child: ListView.builder(
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];

                return ListTile(
                  leading: Icon(method["icon"] as IconData),
                  title: Text(method["name"] as String),
                  trailing: selectedMethod == method["name"]
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedMethod = method["name"] as String;
                    });
                  },
                );
              },
            ),
          ),

          /// 🔥 PAY BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (selectedMethod == null || isProcessing)
                  ? null
                  : () async {
                      setState(() => isProcessing = true);

                      /// 🔥 SIMULATE OPENING UPI APP
                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

                      /// 🔥 SIMULATE RESULT (you can toggle for testing)
                      final success = true;

                      if (success) {
                        Navigator.pop(context, "success");
                      } else {
                        Navigator.pop(context, "failed");
          }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      selectedMethod == null
                          ? "Select Payment Method"
                          : "Pay ₹${widget.amount.toStringAsFixed(2)}",
                    ),
            ),
          ),
        ],
      ),
    );
  }
}