import 'package:printick/services/supabase_service.dart';

class OrderService {
  static Future<Map<String, dynamic>> createOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required String fileUrl,
    required String filePath,
    required String fileName,
    required int pageCount,
    required int copies,
    required bool isColor,
    required double price,
    String paymentStatus = "unpaid", 
    required String paperSize,
    required bool isDoubleSide,
    String? adminNote,
    
  }) async {
    final token = await generateTodayToken();

    /// 🔥 GET QUEUE NUMBER
    final queue = await getQueueNumber();
    print("Generated Token 👉 $token");
    print("Queue Number 👉 $queue");

    final response=await SupabaseService.client.from('orders').insert({
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,

      'file_url': fileUrl,
      'file_path': filePath,
      'file_name': fileName,
      'page_count': pageCount,
      'copies': copies,
      'is_color': isColor,

      'price': price,
      

      'printer_id': 'library_1',
      'queue_number': queue,
      'payment_status': paymentStatus,

      /// defaults handled by DB:
      /// priority, status, payment_status
      
      'is_notified': false,
      'token_number': token,
      'paper_size': paperSize,
      'is_double_side': isDoubleSide,
      'admin_note': adminNote,
      

    })
    .select()
    .single();
    return response;
  }

  /// 🔥 QUEUE LOGIC
  static Future<int> getQueueNumber() async {
    final response = await SupabaseService.client
        .from('orders')
        .select('id')
        // .eq('status', 'pending');
        .eq('printer_id', 'library_1')
        .inFilter('status', ['pending', 'printing']);

    return response.length;
  }

  /// 🔥 USER HISTORY
  static Future<List<dynamic>> getUserOrders(String userId) async {
    final response = await SupabaseService.client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response;
  }

/// 🔥 TOTAL SPENT 
static Future<double> getTotalSpent(String userId) async {
  final response = await SupabaseService.client
      .from('orders')
      .select('price')
      .eq('user_id', userId);

  double total = 0;

  for (var item in response) {
    total += (item['price'] ?? 0).toDouble();
  }

  return total;
}

  /// 🔥 UPDATE STATUS (ADMIN)
static Future<void> updateStatus(String orderId, String status) async {
  final data = {
    'status': status,
  };

  /// ✅ WHEN ORDER COMPLETED → SAVE TIME
  if (status == "completed") {
    data['completed_at'] = DateTime.now().toIso8601String();
  }

  await SupabaseService.client
      .from('orders')
      .update(data)
      .eq('id', orderId);
}

  static Future<String> generateTodayToken() async {
    final now = DateTime.now(); // ✅ LOCAL TIME (IST)

    /// 🔹 Day for token (01–31)
    final day = now.day.toString().padLeft(2, '0');

    /// 🔹 Start of today (LOCAL IST)
    final startOfDayLocal = DateTime(now.year, now.month, now.day);

    /// 🔹 Convert to UTC (for Supabase comparison)
    final startOfDayUtc = startOfDayLocal.toUtc().toIso8601String();

    /// 🔹 Count today's orders
    final response = await SupabaseService.client
        .from('orders')
        .select('id')
        .gte('created_at', startOfDayUtc);

    final count = response.length + 1;

    /// 🔹 Format number (001, 002)
    final number = count.toString().padLeft(3, '0');

    /// 🔹 Final token
    return "${day}T$number";
  }

/// 🔥 TOTAL ORDERS COUNT
static Future<int> getTotalOrders(String userId) async {
  final response = await SupabaseService.client
      .from('orders')
      .select('id')
      .eq('user_id', userId);

  return response.length;
}

/// 🔥 LAST ORDER DATE
static Future<String?> getLastOrderDate(String userId) async {
  final response = await SupabaseService.client
      .from('orders')
      .select('created_at')
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;

  return response['created_at'];
}
}
