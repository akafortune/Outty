import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:outty/core/providers/theme_provider.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';
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

  runApp(
    DevicePreview(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => OnboardingProvider(
            repository: onboardingRepository,
          )),
        
        ],
        child: App(),
      ),
    ),
  );
}
