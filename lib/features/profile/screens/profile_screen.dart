import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outty/core/constants/color_constants.dart';
import 'package:outty/core/constants/text_styles.dart';
import 'package:outty/core/routes/route_names.dart';
import 'package:outty/features/matching/providers/matching_provider.dart';
import 'package:outty/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userDoc = new Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;

    Future<void> DeleteUserData() async {
      await db.collection("Users").where("userID", isEqualTo: uid).get().then((
        querySnapshot,
      ) {
        querySnapshot.docs[0].reference.delete();
      });

      FirebaseAuth.instance.currentUser!.delete();
    }

    Future<List<Uint8List>> GetImages(List<String> urls) async {
      final supabase = Supabase.instance.client;

      List<Uint8List> imageBytesList = [];

      for (int i = 0; i < urls.length - 1; i++) {
        if (urls[i].isEmpty == false) {
          final path = urls[i];
          try {
            imageBytesList.add(
              await supabase.storage.from('Images').download(path),
            );
          } catch (e) {
            debugPrint("Error downloading image from path: $path - $e");
          }
        }
      }

      userDoc['images'] = imageBytesList;
      return imageBytesList;
    }

    Map<String, dynamic> user = {
      'name': userDoc['name'] ?? '',
      'age': 27,
      'location': 'New York, NY',
      'bio': userDoc['bio'] ?? '',
      'images': [],
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

    List<String> GetInterestList() {
      List<String> interestList = userDoc['interests'].toString().split(',');
      return interestList;
    }

    List<String> GetPhotoList() {
      List<String> photoList = userDoc['photos'].toString().split(',');
      debugPrint("Photo list from Firestore: $photoList");
      return photoList;
    }

    Future<void> UpdateUserDisplay() async {
      user = {
        'name': userDoc['name'] ?? '',
        'age': 27,
        'location': 'New York, NY',
        'bio': userDoc['bio'] ?? '',
        'images': await GetImages(GetPhotoList()),
        'interests': GetInterestList(),
        'occupation': 'Software Developer',
        'education': 'Stanford University',
      };
    }

    Future<void> LoadDataFromFirestore() async {
      await db.collection("Users").where("userID", isEqualTo: uid).get().then((
        querySnapshot,
      ) async {
        userDoc = querySnapshot.docs[0].data();
        await UpdateUserDisplay();
      });
    }

    Uint8List _getImageBinary(dynamicList) {
      List<int> intList = dynamicList
          .cast<int>()
          .toList(); //This is the magical line.
      Uint8List data = Uint8List.fromList(intList);
      return data;
    }

    return FutureBuilder(
      future: LoadDataFromFirestore(),
      builder: (context, asyncSnapshot) {
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
                        user['images'] != null && user['images'].isNotEmpty
                            ? Image.memory(
                                _getImageBinary(user['images'][0]),
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
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.grey.shade300,
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
                                '${user['name']}',
                                style: AppTextStyles.h1Light.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.editProfile,
                            );
                          },
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

                        SizedBox(height: 12),

                        ElevatedButton.icon(
                          onPressed: () async {
                            await DeleteUserData();
                            Navigator.pushNamed(context, RouteNames.splash);
                          },
                          label: Text('Delete Profile'),
                          icon: Icon(Icons.edit),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
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

                        const SizedBox(height: 0),

                        Consumer<MatchingProvider>(
                          builder: (context, matchingProvider, child) {
                            final badges = matchingProvider.getPremiumBadges();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        color: badge.color.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: badge.color.withValues(
                                            alpha: 0.5,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
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
                                  color: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
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
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(),
              ],
            ),
          ),
        );
      },
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
