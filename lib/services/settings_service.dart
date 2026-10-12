import 'package:printick/models/app_settings_model.dart';
import 'package:printick/services/supabase_service.dart';

class SettingsService {
  static final client = SupabaseService.client;

  /// MEMORY CACHE
  static AppSettingsModel? _cachedSettings;

  /// GET SETTINGS
  static Future<AppSettingsModel> getSettings() async {

    /// RETURN CACHE
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final response = await client
        .from('app_settings')
        .select()
        .limit(1)
        .single();

    _cachedSettings =
        AppSettingsModel.fromMap(response);

    return _cachedSettings!;
  }

  /// FORCE REFRESH
  static Future<void> refreshSettings() async {
    _cachedSettings = null;
    await getSettings();
  }
}