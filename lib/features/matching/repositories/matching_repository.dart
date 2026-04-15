import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/match_criteria.dart';
import '../models/match_result.dart';
import '../models/badge.dart' as custom_badge;
import '../models/exclusive_content.dart';

class MatchingRepository {
  final rb = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final List<MatchResult> _mockProfiles = [
    MatchResult(
      id: '1',
      name: 'Jessica',
      age: 26,
      distance: '3 miles away',
      distanceValue: 3.0,
      images: ['images/user11.jpg', 'images/user12.jpg'],
      bio:
          'Love hiking and outdoor adventures. Looking for someone to explore with!',
      interests: ['Hiking', 'Photography', 'Travel'],
      isOnline: true,
      occupation: 'Photographer',
      education: 'Art Institute',
      badges: custom_badge.Badge.allBadges,
    ),
    MatchResult(
      id: '2',
      name: 'Michael',
      age: 28,
      distance: '5 miles away',
      distanceValue: 5.0,
      images: ['images/user51.jpg', 'images/user52.jpg'],
      bio:
          'Coffee enthusiast and book lover. Let\'s chat about our favorite novels!',
      interests: ['Reading', 'Coffee', 'Music'],
      isOnline: false,
      occupation: 'Writer',
      education: 'NYU',
      badges: [custom_badge.Badge.allBadges[0]],
    ),
    MatchResult(
      id: '3',
      name: 'Sophia',
      age: 24,
      distance: '2 miles away',
      distanceValue: 2.0,
      images: [
        'images/user21.jpg',
        'images/user22.jpg',
        'images/user23.jpg',
        'images/user24.jpg',
        'images/user25.jpg',
      ],
      bio:
          'Foodie and yoga instructor. Always looking for new restaurants to try!',
      interests: ['Yoga', 'Cooking', 'Restaurants'],
      isOnline: true,
      occupation: 'Yoga Instructor',
      education: 'UCLA',
      badges: [custom_badge.Badge.allBadges[1]],
    ),
    MatchResult(
      id: '4',
      name: 'David',
      age: 29,
      distance: '1 miles away',
      distanceValue: 1.0,
      images: ['images/user41.jpg'],
      bio:
          'Tech enthusiast and fitness lover. Looking for someone to go on runs with!',
      interests: ['Technology', 'Fitness', 'Running', 'Cooking'],
      isOnline: true,
      occupation: 'Software Engineer',
      education: 'MIT',
      badges: [custom_badge.Badge.allBadges[2]],
    ),
    MatchResult(
      id: '5',
      name: 'Emma',
      age: 27,
      distance: '4 miles away',
      distanceValue: 4.0,
      images: ['images/user31.jpg', 'images/user32.jpeg'],
      bio: 'Art lover and museum enthusiast. Always up for cultural events!',
      interests: ['Art', 'Museums', 'Culture', 'History'],
      isOnline: false,
      occupation: 'Curator',
      education: 'School of Visual Arts',
      badges: [],
    ),
  ];

  final List<ExclusiveContent> _mockExclusiveContent = [
    ExclusiveContent(
      id: '1',
      title: 'Dating Success Guide',
      description: 'Learn the secrets to successful online dating',
      imageUrl: 'assets/images/content1.jpg',
      content: '''
#Dating Success Guide

Welcome to your exclusive dating guide! This comprehensive guide will help you navigate the world of online dating with confidence.

## Chapter 1: Creating an Attractive Profile
- Choose the right photos
- Write an engaging bio
- Highlight your unique qualities

## Chapter 2: Making the First Move
- Crafting the perfect opening message
- When to make the first move
- Common mistakes to avoid

## Chapter 3: Building Meaningful Connections
- Effective communication strategies
- Reading between the lines
- Maintaining healthy boundaries
''',
      publishDate: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['Dating Tips', 'Profile', 'Communication'],
      requiredMonths: 0,
    ),

    ExclusiveContent(
      id: '2',
      title: 'Advanced Dating Strategies',
      description: 'Take your dating game to the next level',
      imageUrl: 'assets/images/content2.jpg',
      content: '''
#Advanced Dating Strategies

Ready to level up your dating game? This guide covers advanced strategies for experienced daters.

## Chapter 1: Understanding Dating Psychology
- The science of attraction
- reading body language
- Understanding dating patterns

## Chapter 2: Building Lasting Relationships
- Creating emotional connections
- Managing expectations
- Handling conflicts effectively

## Chapter 3: Long-term Success
- Maintaining relationship health
- Growing together
- Planning for the future
''',
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
      tags: ['Advanced', 'Psychology', 'Relationships'],
      requiredMonths: 1,
    ),

    ExclusiveContent(
      id: '3',
      title: 'Premium Dating Masterclass',
      description: 'Expert dating insights from top dating coaches',
      imageUrl: 'assets/images/content3.jpg',
      content: '''
#Premium Dating Masterclass

Join our exclusive masterclass with insights from top dating coaches and relationship experts.

## Chapter 1: Expert Insights
- Interviews with successful couples
- Professional dating coach tips
- Real-life success stories

## Chapter 2: Advanced Techniques
- Personalized dating strategies
- Understanding compatibility
- Building emotional intelligence

## Chapter 3: Success Stories
- Case studies of successful matches
- Lessons learned
- Tips for maintaining relationships
''',
      publishDate: DateTime.now().subtract(const Duration(days: 15)),
      tags: ['Masterclass', 'Expert', 'Success Stories'],
      requiredMonths: 3,
    ),
  ];

  bool _isPremium = false;

  Future<void> SetPremiumStatus(bool isPremium) async {
    _isPremium = isPremium;
  }

  Future<List<MatchResult>> getMatches(MatchCriteria criteria) async {
    final fbDocs = await FirebaseFirestore.instance.collection("Users").get();
    // List<MatchResult> filteredMatches = _mockProfiles.where((match) {
    //   bool ageMatch =
    //       match.age >= criteria.minAge && match.age <= criteria.maxAge;
    //   bool genderMatch = criteria.gender == 'All' || criteria.gender == 'Both';
    //   bool onlineMatch = !criteria.onlineOnly || match.isOnline;
    //   bool distanceMatch = true;
    //   bool interestMatch =
    //       criteria.interests.isEmpty ||
    //       criteria.interests.any(
    //         (interest) => match.interests.contains(interest),
    //       );

    //   return ageMatch &&
    //       genderMatch &&
    //       onlineMatch &&
    //       distanceMatch &&
    //       interestMatch;
    // }).toList();

    List<MatchResult> filteredMatches = fbDocs.docs
        .map((doc) => MatchResult.fromFirestore(doc.data()))
        .toList();

    if (!criteria.incognitoMode || !_isPremium) {
      _updateLastActive();
    }

    return filteredMatches;
  }

  Future<void> _updateLastActive() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<MatchResult> getMatchById(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final match = _mockProfiles.firstWhere(
      (match) => match.id == matchId,
      orElse: () => throw Exception('Match not found'),
    );

    return match;
  }

  Future<void> saveMatchCriteria(MatchCriteria criteria) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('match_criteria', jsonEncode(criteria.toMap()));
  }

  Future<MatchCriteria> getMatchCriteria() async {
    final prefs = await SharedPreferences.getInstance();
    final String? criteriaJson = prefs.getString('match_criteria');

    if (criteriaJson == null) {
      return MatchCriteria();
    }

    try {
      return MatchCriteria.fromMap(jsonDecode(criteriaJson));
    } catch (e) {
      return MatchCriteria();
    }
  }

  Future<void> likeProfile(String profileId) async {
    rb
        .collection("Users")
        .where("userID", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            var userDoc = querySnapshot.docs.first;
            userDoc.reference.update({
              "likes": FieldValue.arrayUnion([profileId]),
            });
          }
        });

    var likeCon = await rb
        .collection("Users")
        .where("likes", arrayContains: auth.currentUser!.uid)
        .get();

    if (likeCon.docs.isNotEmpty) {
      var userDoc = await rb
          .collection("Users")
          .where("userID", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var userDoc = querySnapshot.docs.first;
              userDoc.reference.update({
                "matches": FieldValue.arrayUnion([profileId]),
              });
            }
          });

      var likeDoc = await rb
          .collection("Users")
          .where("userID", isEqualTo: profileId)
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var userDoc = querySnapshot.docs.first;
              userDoc.reference.update({
                "matches": FieldValue.arrayUnion([auth.currentUser!.uid]),
              });
            }
          });

      FirebaseFirestore.instance.collection("ChatRooms").add({
        "user1ID": auth.currentUser!.uid,
        "user2ID": profileId,
        "roomID": profileId + auth.currentUser!.uid,
      });
    }
  }

  Future<void> dislikeProfile(String profileId) async {
    rb.collection("Likes").add({
      "userFromID": auth.currentUser!.uid,
      "userToID": profileId,
      "likeType": "dislike",
    });
  }

  Future<void> superLikeProfile(String profileId) async {
    await likeProfile(profileId);
  }

  MatchResult createProfileWithDistance(double distanceValue) {
    return MatchResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Test User',
      age: 25,
      distance: '$distanceValue miles away',
      distanceValue: distanceValue,
      images: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      ],
      bio: 'This is a test profile with distance $distanceValue miles away',
      interests: ['Testing', 'Distance Sorting'],
      isOnline: true,
      occupation: 'Tester',
      education: 'Test University',
    );
  }

  Future<List<ExclusiveContent>> getExclusiveContent() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockExclusiveContent;
  }
}
