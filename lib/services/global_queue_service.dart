import 'package:printick/services/supabase_service.dart';

class GlobalQueueService {

  /// 🔥 REALTIME STREAM Wait Time Logic
  static Stream<Map<String, dynamic>> streamGlobalStatus() {

    return SupabaseService.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .map((orders) {

      /// 🔥 FILTER ACTIVE ORDERS
      final activeOrders = orders.where((o) =>
          o['status'] == 'pending' || o['status'] == 'printing').toList();

      int queue = activeOrders.length;

      int totalSeconds = 0;

for (var item in activeOrders) {
  final int p = (item['page_count'] as num?)?.toInt() ?? 1;
  final int c = (item['copies'] as num?)?.toInt() ?? 1;
  final bool isColor = item['is_color'] ?? false;

  /// 🔥 SMART TIME
  final baseTime = 120; // seconds (job setup)
  final perPageTime = isColor ? 5 : 3; // color slower

  final orderTime = baseTime + (p * c * perPageTime);

  totalSeconds += orderTime;
}

      int minutes = (totalSeconds / 60).ceil();
      /// Avoid showing 0 min when queue exists
if (minutes == 0 && queue > 0) {
  minutes = 1;
}

      return {
        "queue": queue,
        "time": minutes,
      };
    });
  }

  /// 🔥 PRINTER STATUS (SEPARATE STREAM)
  static Stream<String> streamPrinterStatus() {
    return SupabaseService.client
        .from('printer')
        .stream(primaryKey: ['id'])
        .map((data) {
      if (data.isEmpty) return "active";
      return data.first['status'] ?? "active";
    });
  }
}