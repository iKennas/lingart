
// services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User session management
  static Future<void> saveUserSession(String userId) async {
    await _prefs?.setString('current_user_id', userId);
  }

  static String? getCurrentUserId() {
    return _prefs?.getString('current_user_id');
  }

  static Future<void> clearUserSession() async {
    await _prefs?.remove('current_user_id');
  }

  // App settings
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString('app_settings', json.encode(settings));
  }

  static Map<String, dynamic> getSettings() {
    final settingsString = _prefs?.getString('app_settings');
    if (settingsString != null) {
      return json.decode(settingsString);
    }
    return {
      'sound_enabled': true,
      'notifications_enabled': true,
      'theme_mode': 'light',
      'language': 'tr',
    };
  }

  // Offline data caching
  static Future<void> cacheData(String key, List<Map<String, dynamic>> data) async {
    await _prefs?.setString(key, json.encode(data));
  }

  static List<Map<String, dynamic>>? getCachedData(String key) {
    final dataString = _prefs?.getString(key);
    if (dataString != null) {
      return List<Map<String, dynamic>>.from(json.decode(dataString));
    }
    return null;
  }

  // Learning progress
  static Future<void> saveProgress(String lessonId, Map<String, dynamic> progress) async {
    final allProgress = getOfflineProgress();
    allProgress[lessonId] = progress;
    await _prefs?.setString('offline_progress', json.encode(allProgress));
  }

  static Map<String, dynamic> getOfflineProgress() {
    final progressString = _prefs?.getString('offline_progress');
    if (progressString != null) {
      return json.decode(progressString);
    }
    return {};
  }
}
