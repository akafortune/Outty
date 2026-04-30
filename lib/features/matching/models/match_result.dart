import 'dart:typed_data';
import 'badge.dart' as custom_badge;

class MatchResult {
  final String id;
  final String name;
  final int age;
  final String distance;
  final double distanceValue;
  final List<Uint8List> images;
  final List<String> imageURLs;
  final String bio;
  final List<String> interests;
  final bool isOnline;
  final String occupation;
  final String education;
  final List<custom_badge.Badge> badges;
  final int difficulty;
  final double compatibility;

  const MatchResult({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.distanceValue,
    required this.images,
    required this.imageURLs,
    required this.bio,
    required this.interests,
    required this.isOnline,
    required this.occupation,
    required this.education,
    required this.difficulty,
    this.badges = const [],
    this.compatibility = 0
  });

  MatchResult copyWith({
    String? id,
    String? name,
    int? age,
    String? distance,
    double? distanceValue,
    List<Uint8List>? images,
    List<String>? imageURLs,
    String? bio,
    List<String>? interests,
    bool? isOnline,
    String? occupation,
    String? education,
    int? difficulty,
    List<custom_badge.Badge>? badges,
    double? compatibility
  }) {
    return MatchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      distanceValue: distanceValue ?? this.distanceValue,
      images: images ?? this.images,
      imageURLs: imageURLs ?? this.imageURLs,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      isOnline: isOnline ?? this.isOnline,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      difficulty: difficulty ?? this.difficulty,
      badges: badges ?? this.badges,
      compatibility: compatibility ?? this.compatibility
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'distance': distance,
      'distanceValue': distanceValue,
      'images': images,
      'imageURLs': imageURLs,
      'bio': bio,
      'interests': interests,
      'isOnline': isOnline,
      'occupation': occupation,
      'education': education,
      'difficulty' : difficulty,
      'badges': badges.map((e) => e.toMap()).toList(),
    };
  }

  factory MatchResult.fromMap(Map<String, dynamic> map) {
    return MatchResult(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? '',
      distance: map['distance'] ?? '',
      distanceValue: map['distanceValue'] ?? 0.0,
      images: [],
      imageURLs: List<String>.from(map['photos'] ?? []),
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      isOnline: map['isOnline'] ?? false,
      occupation: map['occupation'] ?? '',
      education: map['education'] ?? '',
      difficulty: map['difficulty'] ?? 0,
      badges: List<custom_badge.Badge>.from(
        map['badges']?.map((e) => custom_badge.Badge.fromMap(e)) ?? [],
      ),
    );
  }

  factory MatchResult.fromFirestore(Map<String, dynamic> map) {
    List<String> imageURLList = map['photos'].toString().split(',');
    List<String> interestList = map['interests'].toString().split(',');

    return MatchResult(
      id: map['userID'] ?? '',
      name: map['name'] ?? '',
      age: 25,
      distance: 'demo distance',
      distanceValue: 5.0,
      images: [],
      imageURLs: imageURLList,
      bio: map['bio'] ?? '',
      interests: interestList,
      isOnline: map['isOnline'] ?? false,
      occupation: 'demo job',
      education: 'demo education',
      difficulty: map['difficulty'] ?? 0,
      badges: List<custom_badge.Badge>.from(
        map['badges']?.map((e) => custom_badge.Badge.fromMap(e)) ?? [],
      ),
    );
  }

  List<custom_badge.Badge> get premiumBadges =>
      badges.where((badge) => badge.isPremium).toList();
}
