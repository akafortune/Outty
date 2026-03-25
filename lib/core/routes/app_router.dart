import 'package:flutter/material.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/auth/screens/forgot_password_screen.dart';
import 'package:outty/features/auth/screens/login_screen.dart';
import 'package:outty/features/auth/screens/registration_screen.dart';
import 'package:outty/features/auth/screens/verification_screen.dart';
import 'package:outty/features/matching/screens/discover_screen.dart';
import 'package:outty/features/matching/screens/match_details_screen.dart';
import 'package:outty/features/onboarding/screens/interests_screen.dart';
import 'package:outty/features/onboarding/screens/location_permission_screen.dart';
import 'package:outty/features/onboarding/screens/photo_upload_screen.dart';
import 'package:outty/features/onboarding/screens/profile_setup_screen.dart';
import 'package:outty/features/onboarding/screens/welcome_screen.dart';
import 'package:outty/features/splash/screens/splash_screen.dart';

class AppRouter {
  static String get initialRoute => RouteNames.splash;
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.discover:
        return MaterialPageRoute(builder: (_) => const DiscoverScreen());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case RouteNames.verification:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());

      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());

      case RouteNames.photoUpload:
        return MaterialPageRoute(builder: (_) => const PhotoUploadScreen());

      case RouteNames.interests:
        return MaterialPageRoute(builder: (_) => const InterestsScreen());

      case RouteNames.locationPermission:
        return MaterialPageRoute(
          builder: (_) => const LocationPermissionScreen(),
        );

      case RouteNames.matchDetails:
        return MaterialPageRoute(builder: (_) => const MatchDetailsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(('No route defined for ${settings.name}')),
            ),
          ),
        );
    }
  }
}
