import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:outty/core/providers/theme_provider.dart';
import 'package:outty/features/chat/providers/chat_provider.dart';
import 'package:outty/features/chat/repositories/chat_repository.dart';
import 'package:outty/features/matching/providers/matching_provider.dart';
import 'package:outty/features/matching/repositories/matching_repository.dart';
import 'package:outty/features/notifications/providers/notification_provider.dart';
import 'package:outty/features/notifications/repositories/notification_repository.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';
import 'package:outty/features/profile/providers/profile_provider.dart';
import 'package:outty/features/profile/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:outty/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final prefs = await SharedPreferences.getInstance();
    final hasWelcomeKey = prefs.containsKey('has_seen_welcome');
    final welcomeValue = prefs.getBool('has_seen_welcome');
  } catch (e) {
    debugPrint('Shared preferences initialization error: $e');
  }

  final onboardingRepository = OnboardingRepository();
  final matchingRepository = MatchingRepository();
  final profileRepository = ProfileRepository();
  final chatRepository = ChatRepository();
  final notificationRepository = NotificationRepository();

  runApp(
    DevicePreview(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (_) => OnboardingProvider(repository: onboardingRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => MatchingProvider(repository: matchingRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileProvider(repository: profileRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => ChatProvider(repository: chatRepository),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                NotificationProvider(repository: notificationRepository),
          ),
        ],
        child: App(),
      ),
    ),
  );
}
