class AppSettingsModel {

  // ==============================
  // 🔥 BASE PRICING
  // ==============================

  final double bwPrice;
  final double colorPrice;

  final double singleSideMultiplier;
  final double doubleSideMultiplier;

  final double a4Multiplier;
  final double a3Multiplier;
  final double legalMultiplier;

  // ==============================
  // 🔥 FEES & TAXES
  // ==============================

  final double serviceFee;
  final double platformFee;
  final double gstPercent;

  final bool serviceFeeEnabled;
  final bool platformFeeEnabled;
  final bool gstEnabled;

  // ==============================
  // 🔥 DISCOUNTS
  // ==============================

  final bool discountEnabled;
  final bool couponEnabled;

  final double defaultDiscountPercent;
  final double maxDiscountAmount;

  final bool bulkDiscountEnabled;
  final int bulkDiscountThreshold;
  final double bulkDiscountPercent;

  final bool firstOrderFreeEnabled;

  // ==============================
  // 🔥 ORDER RULES
  // ==============================

  final double minimumOrderAmount;

  final bool ordersEnabled;
  final bool maintenanceMode;
  final bool allowGuestOrders;

  // ==============================
  // 🔥 URGENT PRINT
  // ==============================

  final bool urgentPrintEnabled;
  final double urgentPrintMultiplier;

  // ==============================
  // 🔥 LIMITS
  // ==============================

  final int maxUploadSizeMb;
  final int maxPages;
  final int maxCopies;

  // ==============================
  // 🔥 PAYMENTS
  // ==============================

  final bool codEnabled;
  final bool onlinePaymentEnabled;

  // ==============================
  // 🔥 NOTIFICATIONS
  // ==============================

  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;

  // ==============================
  // 🔥 APP CONTROL
  // ==============================

  final String appVersion;
  final bool forceUpdateEnabled;

  // ==============================
  // 🔥 CONSTRUCTOR
  // ==============================

  AppSettingsModel({

    // BASE PRICING
    required this.bwPrice,
    required this.colorPrice,
    required this.singleSideMultiplier,
    required this.doubleSideMultiplier,
    required this.a4Multiplier,
    required this.a3Multiplier,
    required this.legalMultiplier,

    // FEES & TAXES
    required this.serviceFee,
    required this.platformFee,
    required this.gstPercent,
    required this.serviceFeeEnabled,
    required this.platformFeeEnabled,
    required this.gstEnabled,

    // DISCOUNTS
    required this.discountEnabled,
    required this.couponEnabled,
    required this.defaultDiscountPercent,
    required this.maxDiscountAmount,
    required this.bulkDiscountEnabled,
    required this.bulkDiscountThreshold,
    required this.bulkDiscountPercent,
    required this.firstOrderFreeEnabled,

    // ORDER RULES
    required this.minimumOrderAmount,
    required this.ordersEnabled,
    required this.maintenanceMode,
    required this.allowGuestOrders,

    // URGENT PRINT
    required this.urgentPrintEnabled,
    required this.urgentPrintMultiplier,

    // LIMITS
    required this.maxUploadSizeMb,
    required this.maxPages,
    required this.maxCopies,

    // PAYMENTS
    required this.codEnabled,
    required this.onlinePaymentEnabled,

    // NOTIFICATIONS
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,

    // APP CONTROL
    required this.appVersion,
    required this.forceUpdateEnabled,
  });

  // ==============================
  // 🔥 FROM MAP
  // ==============================

  factory AppSettingsModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return AppSettingsModel(

      // ==============================
      // BASE PRICING
      // ==============================

      bwPrice:
          (map['bw_price'] as num?)?.toDouble() ?? 2,

      colorPrice:
          (map['color_price'] as num?)?.toDouble() ?? 10,

      singleSideMultiplier:
          (map['single_side_multiplier'] as num?)
                  ?.toDouble() ??
              1,

      doubleSideMultiplier:
          (map['double_side_multiplier'] as num?)
                  ?.toDouble() ??
              0.7,

      a4Multiplier:
          (map['a4_multiplier'] as num?)
                  ?.toDouble() ??
              1,

      a3Multiplier:
          (map['a3_multiplier'] as num?)
                  ?.toDouble() ??
              1.8,

      legalMultiplier:
          (map['legal_multiplier'] as num?)
                  ?.toDouble() ??
              2,

      // ==============================
      // FEES & TAXES
      // ==============================

      serviceFee:
          (map['service_fee'] as num?)
                  ?.toDouble() ??
              0,

      platformFee:
          (map['platform_fee'] as num?)
                  ?.toDouble() ??
              0,

      gstPercent:
          (map['gst_percent'] as num?)
                  ?.toDouble() ??
              0,

      serviceFeeEnabled:
          map['service_fee_enabled'] ?? true,

      platformFeeEnabled:
          map['platform_fee_enabled'] ?? true,

      gstEnabled:
          map['gst_enabled'] ?? true,

      // ==============================
      // DISCOUNTS
      // ==============================

      discountEnabled:
          map['discount_enabled'] ?? false,

      couponEnabled:
          map['coupon_enabled'] ?? true,

      defaultDiscountPercent:
          (map['default_discount_percent']
                      as num?)
                  ?.toDouble() ??
              0,

      maxDiscountAmount:
          (map['max_discount_amount']
                      as num?)
                  ?.toDouble() ??
              100,

      bulkDiscountEnabled:
          map['bulk_discount_enabled'] ?? false,

      bulkDiscountThreshold:
          map['bulk_discount_threshold'] ?? 50,

      bulkDiscountPercent:
          (map['bulk_discount_percent']
                      as num?)
                  ?.toDouble() ??
              0,

      firstOrderFreeEnabled:
          map['first_order_free_enabled'] ??
              false,

      // ==============================
      // ORDER RULES
      // ==============================

      minimumOrderAmount:
          (map['minimum_order_amount']
                      as num?)
                  ?.toDouble() ??
              10,

      ordersEnabled:
          map['orders_enabled'] ?? true,

      maintenanceMode:
          map['maintenance_mode'] ?? false,

      allowGuestOrders:
          map['allow_guest_orders'] ?? false,

      // ==============================
      // URGENT PRINT
      // ==============================

      urgentPrintEnabled:
          map['urgent_print_enabled'] ??
              true,

      urgentPrintMultiplier:
          (map['urgent_print_multiplier']
                      as num?)
                  ?.toDouble() ??
              1.5,

      // ==============================
      // LIMITS
      // ==============================

      maxUploadSizeMb:
          map['max_upload_size_mb'] ?? 25,

      maxPages:
          map['max_pages'] ?? 500,

      maxCopies:
          map['max_copies'] ?? 100,

      // ==============================
      // PAYMENTS
      // ==============================

      codEnabled:
          map['cod_enabled'] ?? false,

      onlinePaymentEnabled:
          map['online_payment_enabled'] ??
              true,

      // ==============================
      // NOTIFICATIONS
      // ==============================

      pushNotificationsEnabled:
          map['push_notifications_enabled']
                  ??
              true,

      emailNotificationsEnabled:
          map['email_notifications_enabled']
                  ??
              false,

      // ==============================
      // APP CONTROL
      // ==============================

      appVersion:
          map['app_version'] ?? '1.0.0',

      forceUpdateEnabled:
          map['force_update_enabled'] ??
              false,
    );
  }
}