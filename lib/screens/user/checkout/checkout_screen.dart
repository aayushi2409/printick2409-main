import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printick/screens/payment/payment_screen.dart';
import 'package:printick/screens/user/order/order_success_screen.dart';
import 'package:printick/services/supabase_service.dart';
// import 'package:printick/services/supabase_storage_service.dart';
import 'package:printick/services/order_supa_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printick/providers/upload_provider.dart';
import 'package:provider/provider.dart';
import 'package:printick/models/price_breakdown_model.dart';

class CheckoutScreen extends StatefulWidget {
  final String fileName;
  final String fileUrl;
  final int pages;
  final int copies;
  final bool isColor;
  final double price; // price per page
  final String paperSize;
  final bool isDoubleSide;

  final PriceBreakdownModel breakdown;
  

  const CheckoutScreen({
    super.key,
    required this.fileName,
    required this.fileUrl,
    required this.pages,
    required this.copies,
    required this.isColor,
    required this.price,
    required this.paperSize,
    required this.isDoubleSide,

    required this.breakdown
  });


@override
State<CheckoutScreen> createState() =>
    _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {

  final TextEditingController
      noteController =
      TextEditingController();


  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1BAF6), Color(0xFFEABFE9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔹 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _iconBtn(Icons.arrow_back, () {
                      Navigator.pop(context);
                    }),
                    const SizedBox(width: 10),
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 CONTENT
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    /// 🔥 FILE CARD (SMALL + CLEAN)
                    _glassCard(
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.picture_as_pdf, size: 20),
                          ),
                          const SizedBox(width: 10),

                          /// TEXT INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.fileName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                 "${widget.pages} pages • ${widget.copies} copies • ${widget.isColor ? "Color Print" : "Black & White"} • ${widget.paperSize} Size • ${widget.isDoubleSide ? "Double Side Print" : "Single Side Print"}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    /// 🔥 SPECIAL INSTRUCTIONS
_glassCard(
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [

      const Text(
        "Printing Instructions💡",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 12),

     TextField(

  controller: noteController,

  maxLength: 150,
  minLines: 2,
  maxLines: 2,


  style: const TextStyle(
    fontSize: 14,
  ),

  decoration: InputDecoration(

    hintText:
        "Any special printing instructions (Optional)",

    hintStyle: TextStyle(
      color: Colors.black.withOpacity(0.35),
      fontSize: 14,
    ),

    // counterText: "",

    filled: true,

    fillColor:
        Colors.white.withOpacity(0.45),

    border: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
      ),
    ),

    focusedBorder: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(14),

      borderSide: const BorderSide(
        color: Color(0xFF6C63FF),
        width: 1.2,
      ),
    ),

    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
  ),
),
    ],
  ),
),

const SizedBox(height: 12),

                    /// 🔥 BILLING (WITH + VISUAL FLOW)
             _glassCard(
  child: Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    const Text(
      "Bill Summary 💸",
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(height: 18),

_billingRow(

  "Total Printing Cost",

  "₹${(

    widget.pages *
    widget.copies *
    widget.breakdown.pagePrice

  ).toStringAsFixed(2)}",

  subtitle:

      "${widget.pages} Pages × ${widget.copies} Copies × ₹${widget.breakdown.pagePrice.toStringAsFixed(0)}/page",

),

    /// PAPER SIZE
    if (widget.breakdown.paperSize != "A4")
      _billingRow(
        "${widget.breakdown.paperSize} Paper",
        "+ ₹${widget.breakdown.paperSizeCost.toStringAsFixed(2)}",
      ),

    /// DOUBLE SIDE
    if (widget.breakdown.isDoubleSide)
      _billingRow(
        "Double Side Discount",
        "- ₹${widget.breakdown.doubleSideDiscount.toStringAsFixed(2)}",
        isDiscount: true,
      ),

    /// COLOR MODE
    // _billingRow(
    //   "Print Type",
    //   widget.breakdown.isColor
    //       ? "Color Print"
    //       : "Black & White",
    // ),

    const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Divider(),
    ),

    /// SERVICE FEE
    if (widget.breakdown.serviceFeeApplied)
      _billingRow(
        "Service Fee",
        "+ ₹${widget.breakdown.serviceFee.toStringAsFixed(2)}",
      ),

    /// PLATFORM FEE
    if (widget.breakdown.platformFeeApplied)
      _billingRow(
        "Platform Fee",
        "+ ₹${widget.breakdown.platformFee.toStringAsFixed(2)}",
      ),

    /// GST
    if (widget.breakdown.gstApplied)
      _billingRow(
        "GST & Taxes",
        "+ ₹${widget.breakdown.gstAmount.toStringAsFixed(2)}",
      ),

    /// DEFAULT DISCOUNT
    if (widget.breakdown.discountApplied)
      _billingRow(
        "Discount Applied",
        "- ₹${widget.breakdown.discountAmount.toStringAsFixed(2)}",
        isDiscount: true,
      ),

    /// BULK DISCOUNT
    if (widget.breakdown.bulkDiscountApplied)
      _billingRow(
        "Bulk Discount",
        "- ₹${widget.breakdown.bulkDiscountAmount.toStringAsFixed(2)}",
        isDiscount: true,
      ),

    /// COUPON
    if (widget.breakdown.couponApplied)
      _billingRow(
        "Coupon Applied",
        "- ₹${widget.breakdown.couponDiscountAmount.toStringAsFixed(2)}",
        isDiscount: true,
      ),

    const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Divider(),
    ),

    /// TOTAL
    Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        const Text(
          "Grand Total",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          "₹${widget.breakdown.total.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ],
),
),
                  ],
                ),
              ),

              /// 🔥 BOTTOM BAR
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// PRICE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 14)),
                        Text(
                         "₹${widget.breakdown.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    /// PAY BUTTON
                    ElevatedButton(
                      onPressed: () async {
  HapticFeedback.lightImpact();

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please login first")),
    );
    return;
  }

  final total =
    widget.breakdown.total;

  /// 🔥 STEP 1: OPEN PAYMENT SCREEN
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentScreen(amount: total),
    ),
  );

  /// 🔥 USER CANCELLED / FAILED
  if (result != "success") return;

  /// 🔥 Step 2 SHOW LOADING (FAKE PAYMENT)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  // await Future.delayed(const Duration(seconds: 2)); // fake payment

  try {
    /// 🔥 step3  CREATE ORDER (AFTER "PAYMENT")
   final order= await OrderService.createOrder(
      userId: user.uid,
      userName: user.displayName ?? "User",
      userEmail: user.email ?? "",

      fileUrl: widget.fileUrl,
      fileName: widget.fileName,
      filePath: context.read<UploadProvider>().uploadedFilePath!,
      pageCount: widget.pages,

      copies: widget.copies,
      isColor: widget.isColor,

      price: total,

      /// 🔥 IMPORTANT
      paymentStatus: "paid",
      adminNote:
      noteController.text.trim(),
      paperSize: widget.paperSize,
      isDoubleSide: widget.isDoubleSide,
      
    );

    // Navigator.pop(context); // close loader
    /// 🔥 REMOVE TEMP TRACKER

await SupabaseService.client

    .from('temp_uploads')

    .delete()

    .eq(

      'file_path',

      context
          .read<UploadProvider>()
          .uploadedFilePath!,
    );
    
      /// 🔥 STEP 4: RESET UPLOAD SCREEN
    context.read<UploadProvider>().resetStateOnly();

    /// 🔥 STEP 5: GO TO SUCCESS SCREEN (WITH DATA)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
      orderId: order['id'],
      token: order['token_number']?.toString() ?? "--",
      queue: int.tryParse(order['queue_number'].toString()) ?? 1,
      status: order['status']?.toString() ?? "pending",
      pages: widget.pages,
      copies: widget.copies,
      isColor: widget.isColor,
      fileName: widget.fileName,
      paperSize: widget.paperSize,
      isDoubleSide: widget.isDoubleSide,
      
        ),
      ),
    );

  } catch (e) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment failed")),
    );
  }
},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 153, 42),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                      "Pay ₹${widget.breakdown.total.toStringAsFixed(2)}",
  style: const TextStyle(color: Colors.white),
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

  /// 🔹 GLASS CARD
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

Widget _billingRow(
  String title,
  String value, {

  String? subtitle,

  bool isDiscount = false,
}) {

  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 8,
    ),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color:
                      Colors.black.withOpacity(
                    0.8,
                  ),
                ),
              ),

              if (subtitle != null)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 2,
                  ),

                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Colors.black.withOpacity(
                        0.45,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,

            color:
                isDiscount
                    ? Colors.green
                    : Colors.black,
          ),
        ),
      ],
    ),
  );
}

  /// 🔹 ICON BUTTON
  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
    );
  }
}
