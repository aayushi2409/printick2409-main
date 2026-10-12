import 'package:printick/services/supabase_service.dart';

class OrderStateService {
  static final client = SupabaseService.client;

  /// ===============================
  /// 🔥 ACTIVE ORDERS (PRODUCTION)
  /// ===============================
  static Stream<List<Map<String, dynamic>>> streamActiveOrders(String userId) async* {
    try {
      // 🔹 1. INITIAL FETCH
      final initial = await client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['pending', 'printing'])
          .order('created_at', ascending: false);

      yield List<Map<String, dynamic>>.from(initial);

      // 🔹 2. REALTIME STREAM
      final realtimeStream = client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId);

      await for (final data in realtimeStream) {
        final filtered = data
            .where((order) =>
                order['status'] == 'pending' ||
                order['status'] == 'printing')
            .toList();

        // 🔹 sort again (important for consistency)
        filtered.sort((a, b) =>
            (b['created_at']).compareTo(a['created_at']));

        yield List<Map<String, dynamic>>.from(filtered);
      }
    } catch (e) {
      print("ACTIVE ORDER ERROR: $e");
      yield [];
    }
  }

  /// ===============================
  /// 🔥 HISTORY ORDERS (PRODUCTION)
  /// ===============================
  static Stream<List<Map<String, dynamic>>> streamHistoryOrders(String userId) async* {
    try {
      // 🔹 1. INITIAL FETCH
      final initial = await client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('created_at', ascending: false)
          .limit(10);

      yield List<Map<String, dynamic>>.from(initial);

      // 🔹 2. REALTIME STREAM
      final realtimeStream = client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId);

      await for (final data in realtimeStream) {
        final filtered = data
            .where((order) => order['status'] == 'completed')
            .toList();

        filtered.sort((a, b) =>
            (b['created_at']).compareTo(a['created_at']));

        yield List<Map<String, dynamic>>.from(filtered.take(10));
      }
    } catch (e) {
      print("HISTORY ORDER ERROR: $e");
      yield [];
    }
  }

  /// ===============================
  /// 🔥 SINGLE ACTIVE (OPTIONAL)
  /// ===============================
  static Future<Map<String, dynamic>?> getActiveOrder(String userId) async {
    try {
      final response = await client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['pending', 'printing'])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      return response;
    } catch (e) {
      print("SINGLE ORDER ERROR: $e");
      return null;
    }
  }
}