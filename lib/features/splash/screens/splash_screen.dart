import 'dart:async';

import 'package:flutter/material.dart';
import 'package:outty/app.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/core/services/preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.08),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.08, end: 1.0),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    bool hasNavigated = false;

    Timer(const Duration(seconds: 5), () {
      if (mounted && !hasNavigated) {
        hasNavigated = true;
        Navigator.pushReplacementNamed(context, RouteNames.welcome);
      }
    });

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (mounted || hasNavigated) return;

      bool hasSeenWelcome = false;
      bool isLoggedIn = false;

      try {
        hasSeenWelcome = await PreferencesService.hasSeenWelcome();
      } catch (e) {}

      if (hasNavigated) return;
      hasNavigated = true;

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, RouteNames.discover);
      } else if (hasSeenWelcome) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.welcome);
      }
    } catch (e) {
      if (mounted && !hasNavigated) {
        hasNavigated = true;
        Navigator.pushReplacementNamed(context, RouteNames.welcome);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF0F0F1E), Color(0xFF1A1A2E), Color(0xFF16213E)]
                : [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.9),
                  ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -size.width * 0.3,
              left: -size.width * 0.3,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(
                                      isDarkMode ? 0.3 : 0.5,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          Text(
                            AppStrings.appName,
                            style: AppTextStyles.h1Light.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Find your perfect match',
                              style: AppTextStyles.bodyMediumLight.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
