import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.createProfile,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: AppTextStyles.h2Light.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'This information helps us find better matches for you',
                style: AppTextStyles.bodyMediumLight.copyWith(
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 32),

              TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.name,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: isDarkMode
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: textColor),
                onChanged: provider.updateName,
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.bio,
                  prefixIcon: Icon(
                    Icons.edit_note_outlined,
                    color: isDarkMode
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.7),
                  ),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: textColor),
                maxLines: 3,
                onChanged: provider.updateBio,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppStrings.gender,
                  prefixIcon: Icon(
                    Icons.people_outline,
                    color: isDarkMode
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                style: TextStyle(color: textColor),
                items: [AppStrings.male, AppStrings.female]
                    .map(
                      (gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)),
                    )
                    .toList(),
                onChanged: (value) => provider.updateGender(value ?? ''),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.name.isNotEmpty
                      ? () => Navigator.pushNamed(context, RouteNames.photoUpload)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor:  Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    elevation: 0,
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
      ),
    );
  }
}
