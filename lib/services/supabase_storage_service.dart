import 'dart:io';
import 'package:printick/services/supabase_service.dart';

class SupabaseStorageService {
  static Future<Map<String, String>?> uploadPdf(
      File file, String userId) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}.pdf";

      final path = "$userId/$fileName";

      await SupabaseService.client.storage
          .from('upload_doc') // ✅ YOUR BUCKET
          .upload(path, file);

      final url = SupabaseService.client.storage
          .from('upload_doc')
          .getPublicUrl(path);

      return {
        'url': url,
        'path': path,
      };
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  static Future<void> deletePdf(String path) async {
    try {
      await SupabaseService.client.storage
          .from('upload_doc') // ✅ YOUR BUCKET
          .remove([path]);
    } catch (e) {
      print("Delete error: $e");
    }
  }
}