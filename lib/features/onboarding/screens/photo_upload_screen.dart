import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outty/app.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryDark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.photos,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.primary,
        elevation: 0,
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
                      'Add your best photos',
                      style: AppTextStyles.h2Light.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Add at least 2 photos to continue',
                      style: AppTextStyles.bodyMediumLight.copyWith(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final hasPhoto = index < provider.photos.length;

                          return GestureDetector(
                            onTap: () {
                              if (hasPhoto) {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: isDarkMode
                                      ? AppColors.cardDark
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (BuildContext contex) {
                                    return SafeArea(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              width: 40,
                                              height: 4,
                                              margin: EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.grey.shade700
                                                    : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.fullscreen_rounded,
                                                color: AppColors.primary,
                                              ),
                                              title: Text(
                                                'View Photo',
                                                style: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : AppColors
                                                            .textPrimaryLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _showFullScreenImage(
                                                  context,
                                                  provider.photos[index],
                                                  isDarkMode,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red,
                                              ),
                                              title: Text(
                                                'Remove Photo',
                                                style: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : AppColors
                                                            .textPrimaryLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                provider.removePhoto(
                                                  provider.photos[index],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                _pickImage(context, provider);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: hasPhoto
                                      ? Colors.transparent
                                      : AppColors.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                                boxShadow: hasPhoto
                                    ? [
                                        BoxShadow(
                                          color: isDarkMode
                                              ? Colors.black.withValues(
                                                  alpha: 0.3,
                                                )
                                              : Colors.grey.withValues(
                                                  alpha: 0.2,
                                                ),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: hasPhoto
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(provider.photos[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_rounded,
                                        color: AppColors.primary,
                                        size: 32,
                                      ),
                                    ),
                            ),
                          );
                        },
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
                onPressed: provider.photos.length >= 2
                    ? () => Navigator.pushNamed(context, RouteNames.interests)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
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

  void _showFullScreenImage(
    BuildContext context,
    String imagePath,
    bool isDarkMode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Hero(
                  tag: imagePath,
                  child: Image.file(File(imagePath), fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    OnboardingProvider provider,
  ) async {
    final ImagePicker picker = ImagePicker();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? AppColors.cardDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Photo Library',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    if (image != null) {
                      provider.addPhoto(image.path);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );

                    if (image != null) {
                      provider.addPhoto(image.path);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
