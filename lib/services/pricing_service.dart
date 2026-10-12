import 'package:printick/models/price_breakdown_model.dart';
import 'package:printick/services/settings_service.dart';

class PricingService {

  static Future<PriceBreakdownModel> calculatePrice({

    required int pages,
    required int copies,
    required bool isColor,
    required bool isDoubleSide,
    required String paperSize,

    // 🔥 FUTURE READY OPTIONALS
    bool isUrgent = false,
    bool isFirstOrder = false,

    String? couponCode,

  }) async {

    final settings =
        await SettingsService.getSettings();

    // =========================================
    // 🔥 SAFETY VALIDATIONS
    // =========================================

    if (pages <= 0 || copies <= 0) {
      return PriceBreakdownModel.empty();
    }

    if (!settings.ordersEnabled) {

      return PriceBreakdownModel.empty().copyWith(
        pricingMessage:
            "Orders are temporarily disabled",
      );
    }

    if (settings.maintenanceMode) {

      return PriceBreakdownModel.empty().copyWith(
        pricingMessage:
            "App is under maintenance",
      );
    }

    // =========================================
    // 🔥 BASE PAGE PRICE
    // =========================================

    double pagePrice =
        isColor
            ? settings.colorPrice
            : settings.bwPrice;

    // =========================================
    // 🔥 BASE COST
    // =========================================

/// SINGLE COPY BASE
double singleCopyCost =
    pages * pagePrice;

/// COPIES COST
double copiesCost =
    singleCopyCost * copies;

    // =========================================
    // 🔥 SIDE MULTIPLIER
    // =========================================

    double sideMultiplier =
        isDoubleSide
            ? settings.doubleSideMultiplier
            : settings.singleSideMultiplier;

   double sideCost =
    copiesCost * sideMultiplier;

    // =========================================
    // 🔥 PAPER MULTIPLIER
    // =========================================

    double paperMultiplier;

    switch (paperSize) {

      case "A3":
        paperMultiplier =
            settings.a3Multiplier;
        break;

      case "LEGAL":
        paperMultiplier =
            settings.legalMultiplier;
        break;

      case "A4":
      default:
        paperMultiplier =
            settings.a4Multiplier;
    }

    double paperCost =
        sideCost * paperMultiplier;
    double paperSizeCost =
        paperCost - sideCost;

    double doubleSideDiscount =
        copiesCost - sideCost;    

    // =========================================
    // 🔥 START SUBTOTAL
    // =========================================

    double subtotal = paperCost;

    // =========================================
    // 🔥 URGENT PRINT
    // =========================================

    double urgentPrintCost = 0;

    bool urgentPrintApplied = false;

    if (isUrgent &&
        settings.urgentPrintEnabled) {

      urgentPrintCost =
          subtotal *
          (settings.urgentPrintMultiplier - 1);

      subtotal += urgentPrintCost;

      urgentPrintApplied = true;
    }

    // =========================================
    // 🔥 SERVICE FEE
    // =========================================

    double serviceFee = 0;

    bool serviceFeeApplied = false;

    if (settings.serviceFeeEnabled) {

      serviceFee =
          settings.serviceFee;

      subtotal += serviceFee;

      serviceFeeApplied = true;
    }

    // =========================================
    // 🔥 PLATFORM FEE
    // =========================================

    double platformFee = 0;

    bool platformFeeApplied = false;

    if (settings.platformFeeEnabled) {

      platformFee =
          settings.platformFee;

      subtotal += platformFee;

      platformFeeApplied = true;
    }

    // =========================================
    // 🔥 DEFAULT DISCOUNT
    // =========================================

    double discountAmount = 0;

    bool discountApplied = false;

    if (settings.discountEnabled &&
        settings.defaultDiscountPercent > 0) {

      discountAmount =
          subtotal *
          (settings.defaultDiscountPercent / 100);

      // 🔥 MAX DISCOUNT LIMIT

      if (discountAmount >
          settings.maxDiscountAmount) {

        discountAmount =
            settings.maxDiscountAmount;
      }

      subtotal -= discountAmount;

      discountApplied = true;
    }

    // =========================================
    // 🔥 BULK DISCOUNT
    // =========================================

    double bulkDiscountAmount = 0;

    bool bulkDiscountApplied = false;

    if (settings.bulkDiscountEnabled &&
        copies >=
            settings.bulkDiscountThreshold) {

      bulkDiscountAmount =
          subtotal *
          (settings.bulkDiscountPercent / 100);

      subtotal -= bulkDiscountAmount;

      bulkDiscountApplied = true;
    }

    // =========================================
    // 🔥 FIRST ORDER FREE
    // =========================================

    double firstOrderDiscountAmount = 0;

    bool firstOrderFreeApplied = false;

    if (settings.firstOrderFreeEnabled &&
        isFirstOrder) {

      firstOrderDiscountAmount =
          subtotal;

      subtotal = 0;

      firstOrderFreeApplied = true;
    }

    // =========================================
    // 🔥 COUPON SYSTEM
    // =========================================

    double couponDiscountAmount = 0;

    bool couponApplied = false;

    String? appliedCouponCode;

    /// 🔥 FUTURE:
    /// coupon table lookup
    /// validation
    /// expiry checks
    /// usage checks

    if (settings.couponEnabled &&
        couponCode != null &&
        couponCode.trim().isNotEmpty) {

      // TEMP DEMO LOGIC

      if (couponCode.toUpperCase() ==
          "PRINT50") {

        couponDiscountAmount =
            subtotal * 0.5;

        subtotal -= couponDiscountAmount;

        couponApplied = true;

        appliedCouponCode =
            couponCode;
      }
    }

    // =========================================
    // 🔥 GST
    // =========================================

    double gstAmount = 0;

    bool gstApplied = false;

    if (settings.gstEnabled &&
        settings.gstPercent > 0) {

      gstAmount =
          subtotal *
          (settings.gstPercent / 100);

      subtotal += gstAmount;

      gstApplied = true;
    }

    // =========================================
    // 🔥 MINIMUM ORDER VALUE
    // =========================================

    if (subtotal <
        settings.minimumOrderAmount) {

      subtotal =
          settings.minimumOrderAmount;
    }

    // =========================================
    // 🔥 FINAL TOTAL
    // =========================================

    double total = subtotal;

    // =========================================
    // 🔥 RETURN BREAKDOWN
    // =========================================

    return PriceBreakdownModel(

      // BASE
      basePrice: singleCopyCost,      
      sideCost: sideCost,
      paperCost: paperCost,
      urgentPrintCost: urgentPrintCost,

      // FEES
      serviceFee: serviceFee,
      platformFee: platformFee,

      // DISCOUNTS
      discountAmount: discountAmount,
      couponDiscountAmount:
          couponDiscountAmount,
      bulkDiscountAmount:
          bulkDiscountAmount,
      firstOrderDiscountAmount:
          firstOrderDiscountAmount,

      // GST
      gstAmount: gstAmount,

      // TOTALS
      subtotal: subtotal,
      total: total,

      // FLAGS
      discountApplied:
          discountApplied,

      couponApplied:
          couponApplied,

      bulkDiscountApplied:
          bulkDiscountApplied,

      firstOrderFreeApplied:
          firstOrderFreeApplied,

      gstApplied:
          gstApplied,

      platformFeeApplied:
          platformFeeApplied,

      serviceFeeApplied:
          serviceFeeApplied,

      urgentPrintApplied:
          urgentPrintApplied,

      // OPTIONAL
      appliedCouponCode:
          appliedCouponCode,

      pricingMessage: null,


      pagePrice: pagePrice,

  // DISPLAY INFO
totalPages: pages,
copies: copies,
paperSize: paperSize,
isDoubleSide: isDoubleSide,
isColor: isColor,

copiesCost: copiesCost,
paperSizeCost: paperSizeCost,
doubleSideDiscount:
    isDoubleSide
        ? doubleSideDiscount.abs()
        : 0,


    );
  }
}