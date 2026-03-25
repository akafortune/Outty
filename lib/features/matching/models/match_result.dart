import 'badge.dart' as custom_badge;

class MatchResult {
  final String id;
  final String name;
  final int age;
  final String distance;
  final double distanceValue;
  final List<String> images;
  final String bio;
  final List<String> interests;
  final bool isOnline;
  final String occupation;
  final String education;
  final List<custom_badge.Badge> badges;

  const MatchResult({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.distanceValue,
    required this.images,
    required this.bio,
    required this.interests,
    required this.isOnline,
    required this.occupation,
    required this.education,
    this.badges = const [],
  });

  MatchResult copyWith({
    String? id,
    String? name,
    int? age,
    String? distance,
    double? distanceValue,
    List<String>? images,
    String? bio,
    List<String>? interests,
    bool? isOnline,
    String? occupation,
    String? education,
    List<custom_badge.Badge>? badges,
  }) {
    return MatchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      distanceValue: distanceValue ?? this.distanceValue,
      images: images ?? this.images,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      isOnline: isOnline ?? this.isOnline,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      badges: badges ?? this.badges,
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
      'bio': bio,
      'interests': interests,
      'isOnline': isOnline,
      'occupation': occupation,
      'education': education,
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
      images: List<String>.from(map['images'] ?? []),
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      isOnline: map['isOnline'] ?? false,
      occupation: map['occupation'] ?? '',
      education: map['education'] ?? '',
      badges: List<custom_badge.Badge>.from(
        map['badges']?.map((e) => custom_badge.Badge.fromMap(e)) ?? [],
      ),
    );
  }

  List<custom_badge.Badge> get premiumBadges =>
      badges.where((badge) => badge.isPremium).toList();
}
