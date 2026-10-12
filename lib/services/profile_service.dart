import 'package:printick/services/supabase_service.dart';

class ProfileService {
  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .single();

    return response;
  }
  static Future<void> updateProfile({
  required String userId,
  required Map<String, dynamic> data,
}) async {
  final response = await SupabaseService.client
      .from('profiles')
      .update(data)
      .eq('user_id', userId);

  print("UPDATE RESPONSE: $response"); // 🔥 DEBUG
}


}