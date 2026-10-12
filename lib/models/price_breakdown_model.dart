class PriceBreakdownModel {

  // =========================================
  // 🔥 BASE PRICE COMPONENTS
  // =========================================

  final double basePrice;

  final double sideCost;

  final double paperCost;

  final double urgentPrintCost;

  // =========================================
  // 🔥 FEES
  // =========================================

  final double serviceFee;

  final double platformFee;

  // =========================================
  // 🔥 DISCOUNTS
  // =========================================

  final double discountAmount;

  final double couponDiscountAmount;

  final double bulkDiscountAmount;

  final double firstOrderDiscountAmount;

  // =========================================
  // 🔥 TAX
  // =========================================

  final double gstAmount;

  // =========================================
  // 🔥 FINAL TOTAL
  // =========================================

  final double subtotal;

  final double total;

  // =========================================
  // 🔥 FEATURE FLAGS
  // =========================================

  final bool discountApplied;

  final bool couponApplied;

  final bool bulkDiscountApplied;

  final bool firstOrderFreeApplied;

  final bool gstApplied;

  final bool platformFeeApplied;

  final bool serviceFeeApplied;

  final bool urgentPrintApplied;

  // =========================================
  // 🔥 OPTIONAL INFO
  // =========================================

  final String? appliedCouponCode;

  final String? pricingMessage;

//Display info
final double pagePrice;
final int totalPages;
final int copies;
final String paperSize;
final bool isDoubleSide;
final bool isColor;
final double copiesCost;
final double paperSizeCost;
final double doubleSideDiscount;
  // =========================================
  // 🔥 CONSTRUCTOR
  // =========================================

  PriceBreakdownModel({

    // BASE
    required this.basePrice,
    required this.sideCost,
    required this.paperCost,
    required this.urgentPrintCost,

    // FEES
    required this.serviceFee,
    required this.platformFee,

    // DISCOUNTS
    required this.discountAmount,
    required this.couponDiscountAmount,
    required this.bulkDiscountAmount,
    required this.firstOrderDiscountAmount,

    // TAX
    required this.gstAmount,

    // TOTALS
    required this.subtotal,
    required this.total,

    // FLAGS
    required this.discountApplied,
    required this.couponApplied,
    required this.bulkDiscountApplied,
    required this.firstOrderFreeApplied,
    required this.gstApplied,
    required this.platformFeeApplied,
    required this.serviceFeeApplied,
    required this.urgentPrintApplied,

    // OPTIONAL
    this.appliedCouponCode,
    this.pricingMessage,

//Display Info
required this.pagePrice,
required this.totalPages,
required this.copies,
required this.paperSize,
required this.isDoubleSide,
required this.isColor,
required this.copiesCost,
required this.paperSizeCost,
required this.doubleSideDiscount,

  });

  // =========================================
  // 🔥 EMPTY FACTORY
  // =========================================

  factory PriceBreakdownModel.empty() {

    return PriceBreakdownModel(

      // BASE
      basePrice: 0,
      sideCost: 0,
      paperCost: 0,
      urgentPrintCost: 0,

      // FEES
      serviceFee: 0,
      platformFee: 0,

      // DISCOUNTS
      discountAmount: 0,
      couponDiscountAmount: 0,
      bulkDiscountAmount: 0,
      firstOrderDiscountAmount: 0,

      // TAX
      gstAmount: 0,

      // TOTALS
      subtotal: 0,
      total: 0,

      // FLAGS
      discountApplied: false,
      couponApplied: false,
      bulkDiscountApplied: false,
      firstOrderFreeApplied: false,
      gstApplied: false,
      platformFeeApplied: false,
      serviceFeeApplied: false,
      urgentPrintApplied: false,

      // OPTIONAL
      appliedCouponCode: null,
      pricingMessage: null,

  // DISPLAY INFO
pagePrice: 0,
totalPages: 0,
copies: 0,
paperSize: "A4",
isDoubleSide: false,
isColor: false,
copiesCost: 0,
paperSizeCost: 0,
doubleSideDiscount: 0,
    );
  }

  // =========================================
  // 🔥 COPY WITH
  // =========================================

  PriceBreakdownModel copyWith({

    double? basePrice,
    double? sideCost,
    double? paperCost,
    double? urgentPrintCost,

    double? serviceFee,
    double? platformFee,

    double? discountAmount,
    double? couponDiscountAmount,
    double? bulkDiscountAmount,
    double? firstOrderDiscountAmount,

    double? gstAmount,

    double? subtotal,
    double? total,

    bool? discountApplied,
    bool? couponApplied,
    bool? bulkDiscountApplied,
    bool? firstOrderFreeApplied,
    bool? gstApplied,
    bool? platformFeeApplied,
    bool? serviceFeeApplied,
    bool? urgentPrintApplied,

    String? appliedCouponCode,
    String? pricingMessage,

    double? pagePrice,

//display info
int? totalPages,
int? copies,
String? paperSize,
bool? isDoubleSide,
bool? isColor,
double? copiesCost,
double? paperSizeCost,
double? doubleSideDiscount,

  }) {

    return PriceBreakdownModel(

      // BASE
      basePrice:
          basePrice ?? this.basePrice,

      sideCost:
          sideCost ?? this.sideCost,

      paperCost:
          paperCost ?? this.paperCost,

      urgentPrintCost:
          urgentPrintCost ??
              this.urgentPrintCost,

      // FEES
      serviceFee:
          serviceFee ?? this.serviceFee,

      platformFee:
          platformFee ?? this.platformFee,

      // DISCOUNTS
      discountAmount:
          discountAmount ??
              this.discountAmount,

      couponDiscountAmount:
          couponDiscountAmount ??
              this.couponDiscountAmount,

      bulkDiscountAmount:
          bulkDiscountAmount ??
              this.bulkDiscountAmount,

      firstOrderDiscountAmount:
          firstOrderDiscountAmount ??
              this.firstOrderDiscountAmount,

      // TAX
      gstAmount:
          gstAmount ?? this.gstAmount,

      // TOTALS
      subtotal:
          subtotal ?? this.subtotal,

      total:
          total ?? this.total,

      // FLAGS
      discountApplied:
          discountApplied ??
              this.discountApplied,

      couponApplied:
          couponApplied ??
              this.couponApplied,

      bulkDiscountApplied:
          bulkDiscountApplied ??
              this.bulkDiscountApplied,

      firstOrderFreeApplied:
          firstOrderFreeApplied ??
              this.firstOrderFreeApplied,

      gstApplied:
          gstApplied ?? this.gstApplied,

      platformFeeApplied:
          platformFeeApplied ??
              this.platformFeeApplied,

      serviceFeeApplied:
          serviceFeeApplied ??
              this.serviceFeeApplied,

      urgentPrintApplied:
          urgentPrintApplied ??
              this.urgentPrintApplied,

      // OPTIONAL
      appliedCouponCode:
          appliedCouponCode ??
              this.appliedCouponCode,

      pricingMessage:
          pricingMessage ??
              this.pricingMessage,

                // DISPLAY INFO
      pagePrice:
          pagePrice ?? this.pagePrice,

      totalPages:
          totalPages ?? this.totalPages,

      copies:
          copies ?? this.copies,

      paperSize:
          paperSize ?? this.paperSize,

      isDoubleSide:
          isDoubleSide ?? this.isDoubleSide,

      isColor:
          isColor ?? this.isColor,

      copiesCost:
    copiesCost ?? this.copiesCost,

      paperSizeCost:
    paperSizeCost ?? this.paperSizeCost,

      doubleSideDiscount:
    doubleSideDiscount ??
        this.doubleSideDiscount,        
    );
  }
}