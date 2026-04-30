import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/match_criteria.dart';
import '../models/match_result.dart';
import '../models/badge.dart' as custom_badge;
import '../models/exclusive_content.dart';

class MatchingRepository {
  final rb = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

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
    var userID = FirebaseAuth.instance.currentUser!.uid;

    final fbDocs = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isNotEqualTo: userID)
        .get();

    List<MatchResult> filteredMatches = fbDocs.docs
        .map((doc) => MatchResult.fromFirestore(doc.data()))
        .toList();

    final thisUserDoc = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isEqualTo: userID)
        .get();

    MatchResult userMR = thisUserDoc.docs
        .map((doc) => MatchResult.fromFirestore(doc.data()))
        .first;

    final supabase = Supabase.instance.client;
    List<MatchResult> finalMatches = <MatchResult>[];

    for (MatchResult match in filteredMatches) {
      
      double compatibilityScore = _matchingEngine(userMR, match);

      List<Uint8List> imageBytesList = [];

      debugPrint(
        'Processing match: ${match.name} with image URLs: ${match.imageURLs}',
      );

      for (int i = 0; i < match.imageURLs.length - 1; i++) {
        final path = match.imageURLs[i];

        debugPrint("Downloading image from path: $path");

        try {
          imageBytesList.add(
            await supabase.storage.from('Images').download(path),
          );
        } catch (e) {
          debugPrint("Error downloading image from path: $path - $e");
        }
      }

      match = match.copyWith(images: imageBytesList, compatibility: compatibilityScore);
      finalMatches.add(match);
    }

    if (!criteria.incognitoMode || !_isPremium) {
      _updateLastActive();
    }

    finalMatches.sort((a,b) => a.compatibility.compareTo(b.compatibility));

    return finalMatches;
  }

  double _matchingEngine(MatchResult user, MatchResult other){
    double compatibilityScore = 0.0;

    for(String interest in user.interests){
      if(other.interests.contains(interest)){
        compatibilityScore += 15.0;
      }
    }

    int difficultyDifference = user.difficulty - other.difficulty;

    difficultyDifference.abs();

    if(difficultyDifference <= 1){
      compatibilityScore += 45;
    } else if (difficultyDifference <= 3){
      compatibilityScore += 30;
    } else if (difficultyDifference <= 5){
      compatibilityScore += 15;
    } else if (difficultyDifference <= 7){
      compatibilityScore += 0;
    } else {
      compatibilityScore -= 15;
    }

    double distanceDifference = user.distanceValue - other.distanceValue;

    if(distanceDifference <= 5){
      compatibilityScore += 45;
    } else if(distanceDifference <= 15){
      compatibilityScore += 30;
    } else if(distanceDifference <= 25){
      compatibilityScore += 15;
    } else if(distanceDifference <= 40){
      compatibilityScore += 0;
    } else {
      compatibilityScore -= 30;
    }

    return compatibilityScore;
  }

  Future<void> _updateLastActive() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<MatchResult> getMatchById(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final match = MatchResult(
      id: matchId,
      name: 'Test User',
      age: 25,
      distance: '5 miles away',
      distanceValue: 5.0,
      images: [],
      imageURLs: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      ],
      bio: 'This is a test profile with distance 5 miles away',
      interests: ['Testing', 'Distance Sorting'],
      difficulty: 0,
      isOnline: true,
      occupation: 'Tester',
      education: 'Test University',
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

      var matchDoc = await FirebaseFirestore.instance
          .collection("ChatRooms")
          .add({
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
      imageURLs: [],
      images: [],
      difficulty: 0,
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
