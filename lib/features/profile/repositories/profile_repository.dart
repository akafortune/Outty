import 'package:outty/features/profile/models/profile_details.dart';
import 'package:outty/features/profile/models/profile_photo.dart';

class ProfileRepository {
  Future<ProfileDetails> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return ProfileDetails(
      id: 'user123',
      name: 'Alex Johnson',
      age: 27,
      location: 'New York, NY',
      bio:
          'Adventure seeker and coffee enthusiast, Love hiking, photography and trying new restaurants',
      interests: [
        'Hiking',
        'Photography',
        'Travel',
        'Coffee',
        'Cooking',
        'Music',
      ],
      occupation: 'Software Developer',
      education: 'Stanford University',
      isPremium: false,
      joinDate: DateTime(2022, 5, 15),
      preferences: {
        'showLocation': true,
        'showAge': true,
        'darkMode': true,
        'notifications': true,
        'matchAlerts': true,
        'messageAlerts': true,
      },
    );
  }

  Future<List<ProfilePhoto>> getUserPhotos(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      ProfilePhoto(
        id: 'photo1',
        url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        isPrimary: true,
        uploadDate: DateTime(2022, 6, 10),
      ),
      ProfilePhoto(
        id: 'photo2',
        url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        isPrimary: false,
        uploadDate: DateTime(2022, 6, 15),
      ),
      ProfilePhoto(
        id: 'photo3',
        url: 'https://images.unsplash.com/photo-1534030347209-467a5b0ad3e6',
        isPrimary: false,
        uploadDate: DateTime(2022, 7, 1),
      ),
    ];
  }

  Future<void> updateProfile(ProfileDetails profile) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  Future<void> updatePhotos(List<ProfilePhoto> photos) async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  Future<void> updatePreferences(Map<String, bool> preferences) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> upgradeToPremium() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
