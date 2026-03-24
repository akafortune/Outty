import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class InterestsScreen extends StatelessWidget {
  const InterestsScreen({super.key});

  static const List<String> _availableInterests = [
    'Hiking',
    'Skateboarding',
    'Kayaking',
    'Running',
    'Mountain Biking',
    'Skiing',
    'Skydiving',
    'Camping',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.interests,
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
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What are you into?',
                      style: AppTextStyles.h2Light.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Select at least 3 interests',
                      style: AppTextStyles.bodyMediumLight.copyWith(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            '${provider.interests.length} selected',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _availableInterests.map((interest) {
                          final isSelected = provider.interests.contains(
                            interest,
                          );
                          return AnimatedScale(
                            scale: isSelected ? 1.05 : 1.0,
                            duration: const Duration(microseconds: 150),
                            child: FilterChip(
                              label: Text(interest),
                              onSelected: (_) =>
                                  provider.toggleInterest(interest),
                              backgroundColor: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              selectedColor: isDarkMode
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.primaryLight,
                              checkmarkColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : isDarkMode
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(16),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              elevation: isSelected ? 2 : 0,
                              pressElevation: 0,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: provider.interests.length >= 3 ? ()=> Navigator.pushNamed(context, RouteNames.locationPermission) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  disabledForegroundColor: isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade500,
                ),
                child: Text(
                  AppStrings.next,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
