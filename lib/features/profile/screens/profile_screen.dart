import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/features/matching/providers/matching_provider.dart';
import 'package:outty/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Map<String, dynamic> user = {
      'name': 'Alex Johnson',
      'age': 27,
      'location': 'New York, NY',
      'bio':
          'Adventure seeker and coffee enthusiast. Love hiking, photography and trying new restaurants',
      'images': [
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        'https://images.unsplash.com/photo-1534030347209-467a5b0ad3e6',
      ],
      'interests': [
        'Hiking',
        'Photography',
        'Travel',
        'Coffee',
        'Cooking',
        'Music',
      ],
      'occupation': 'Software Developer',
      'education': 'Stanford University',
    };

    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: isDarkMode
                  ? AppColors.backgroundDark
                  : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      user['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user['name']} ${user['age']}',
                            style: AppTextStyles.h1Light.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user['location'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings_outlined),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: Text('Edit Profile'),
                      icon: Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Consumer<MatchingProvider>(
                      builder: (context, matchingProvider, child) {
                        final badges = matchingProvider.getPremiumBadges();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Badges',
                              style: AppTextStyles.h3Light.copyWith(
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: badges.map((badge) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badge.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: badge.color.withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        badge.icon,
                                        size: 16,
                                        color: badge.color,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        badge.name,
                                        style: TextStyle(
                                          color: badge.color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    ),
                    Text(
                      'About',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user['bio'],
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (user['interests'] as List<String>).map((
                        interest,
                      ) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Basic Info',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),
                    _infoItem(
                      icon: Icons.work_outline,
                      label: 'Occupation',
                      value: user['occupation'],
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 8),
                    _infoItem(
                      icon: Icons.school_outlined,
                      label: 'Education',
                      value: user['education'],
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 8),
                    _infoItem(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: user['location'],
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 32),

                    OutlinedButton.icon(
                      onPressed: () {},
                      label: Text('Settings'),
                      icon: Icon(Icons.settings_outlined),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDarkMode
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
