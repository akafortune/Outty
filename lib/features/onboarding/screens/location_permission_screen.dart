import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/core/widdgets/custom_button.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  late int difficulty;

  @override
  void initState() {
    super.initState();
    difficulty = 2;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thrill Level',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.primary,
      ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Select your Thrill Level',
              style: AppTextStyles.h1Light.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'How much excitement are you looking for?',
              style: AppTextStyles.bodyMediumLight.copyWith(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 200),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.2),
                valueIndicatorColor: AppColors.primary,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: difficulty.toDouble(),
                max: 10,
                min: 1,
                divisions: 9,
                label: difficulty.toString(),
                onChanged: (value) {
                  setState(() {
                    difficulty = value.round();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  '1',
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
                Text(
                  '10',
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 280),

            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Create Profile',
                    icon: Icons.person_2_outlined,
                    onPressed: () async {
                      provider.setLocationPermission(true);
                      provider.updateDifficulty(difficulty);
                      await provider.saveOnboardingData();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.discover,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
