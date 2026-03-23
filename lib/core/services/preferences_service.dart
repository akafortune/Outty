import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenWelcomeKey = 'has_seen_welcome';

  static Future<bool> hasSeenWelcome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool(_hasSeenWelcomeKey) ?? false;
      debugPrint('hasSeenWelcome check: $result');
      return result;
    } catch (e) {
      debugPrint('Error checking welcome screen status: $e');
      return false;
    }
  }

  static Future<void> setWelcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenWelcomeKey, true);
      final wasSet = prefs.getBool(_hasSeenWelcomeKey) ?? false;
      debugPrint('Welcome screen marked as seen: $wasSet');
    } catch (e) {
      debugPrint('Error setting welcome screen as seen: $e');
    }
  }

  static Future<void> resetWelcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenWelcomeKey, true);
      debugPrint('Welcome screen preference reset');
    } catch (e) {
      debugPrint('Error resetting welcome screen status: $e');
    }
  }
}
