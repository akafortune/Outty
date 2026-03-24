import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/core/widdgets/custom_button.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryDark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
            colors: isDarkMode
                ? [AppColors.cardDark, AppColors.backgroundDark]
                : [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Enable Location',
                        style: AppTextStyles.h2Light.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'We use your location to show you potential matches in your area',
                        style: AppTextStyles.bodyMediumLight.copyWith(
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Allow Location Access',
                        icon: Icons.location_on,
                        onPressed: () async {
                          provider.setLocationPermission(true);
                          await provider.saveOnboardingData();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.discover,
                            (route) => false,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(text: 'Skip for now',
                      type: ButtonType.secondary,
                      onPressed: (){
                        Navigator.pop(context);
                      },)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
