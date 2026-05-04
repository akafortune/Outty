import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outty/features/chat/repositories/chat_repository.dart';
import 'package:outty/features/matching/models/match_criteria.dart';
import 'package:outty/features/matching/models/match_result.dart';
import 'package:outty/features/matching/providers/matching_provider.dart';
import 'package:outty/features/matching/repositories/matching_repository.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';
import 'package:outty/features/profile/providers/profile_provider.dart';
import 'package:outty/features/profile/repositories/profile_repository.dart';
import 'package:outty/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';

void main() async {
  //Unit Tests

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://hgidnniihheisqahstor.supabase.co',
    anonKey: 'sb_publishable_pmejkrmWKChdlH7GrofJzA_WKUF8evu',
  );

  final supabase = Supabase.instance.client;

  var userDocRef = await FirebaseFirestore.instance
      .collection("Users")
      .doc("testing user")
      .get();
  var userDoc = userDocRef.data();

  group('Unit Tests', () {
    test('Get difficulty from firebase', () {
      String difficulty = userDoc!["difficulty"];

      expect(difficulty, '0');
    });

    test('Get difficulty from fiurebase', () async {
      Uint8List demoUint =
          DateTime(2024, 1, 1).millisecondsSinceEpoch.toString().codeUnits
              as Uint8List;

      supabase.storage
          .from('Images')
          .uploadBinary('testing_user.png', demoUint);

      Uint8List? retrievedData = await supabase.storage
          .from('Images')
          .download('testing_user.png');

      expect(retrievedData, demoUint);
    });

    test('Test matching algorithm 1', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t3 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 0,
      );

      double overlap1 = t1.calculateCompatibility(t2);
      double overlap2 = t1.calculateCompatibility(t3);

      bool isT2MoreCompatible = overlap1 > overlap2;

      expect(isT2MoreCompatible, true);
    });

    test('Test matching algorithm 2', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['nothin', 'nothing', 'nothing'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t3 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      double overlap1 = t1.calculateCompatibility(t2);
      double overlap2 = t1.calculateCompatibility(t3);

      bool isT2MoreCompatible = overlap1 > overlap2;

      expect(isT2MoreCompatible, false);
    });

    test('Test matching algorithm 3', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 20.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      MatchResult t3 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 4,
      );

      double overlap1 = t1.calculateCompatibility(t2);
      double overlap2 = t1.calculateCompatibility(t3);

      bool isT2MoreCompatible = overlap1 > overlap2;

      expect(isT2MoreCompatible, false);
    });

    test('Update name from firebase', () async {
      userDocRef.reference.update({'name': 'testing user'});

      expect(userDocRef['name'], 'testing user');

      userDocRef.reference.update({'name': 'test'});
    });

    test('Update bio from firebase', () async {
      userDocRef.reference.update({'bio': 'This is a test bio'});

      expect(userDocRef['bio'], 'This is a test bio');

      userDocRef.reference.update({'bio': 'hello'});
    });

    test('Update education from firebase', () async {
      userDocRef.reference.update({'education': 'Princeton'});

      expect(userDocRef['education'], 'Princeton');

      userDocRef.reference.update({'education': 'none'});
    });

    test('Update occupation from firebase', () async {
      userDocRef.reference.update({'occupation': 'Engineer'});

      expect(userDocRef['occupation'], 'Engineer');

      userDocRef.reference.update({'occupation': 'none'});
    });

    test('Update age from firebase', () async {
      userDocRef.reference.update({'age': 25});

      expect(userDocRef['age'], 25);

      userDocRef.reference.update({'age': 0});
    });
  });

  group('TDD', () {
    //TDD Tests
    test('Test matching algorithm: interest overlap', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 0,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 10.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 0,
      );

      double overlap = t1.InterestOverlap(t2);

      expect(overlap, 45);
    });

    test('Test matching algorithm: distance score', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: [],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 0,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: [],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 0,
      );

      double distScore = t1.DistanceScore(t2);

      expect(distScore, 45.0);
    });

    test('Test matching algorithm: difficulty score', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: [],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 5,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: [],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 5,
      );

      double diffScore = t1.DifficultyScore(t2);

      expect(diffScore, 40.0);
    });

    test('Test matching algorithm: full algorithm', () async {
      MatchResult t1 = MatchResult(
        id: '1',
        name: 'test user 1',
        age: 25,
        distance: '5 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 5,
      );

      MatchResult t2 = MatchResult(
        id: '2',
        name: 'test user 2',
        age: 30,
        distance: '10 miles',
        distanceValue: 5.0,
        images: [],
        imageURLs: [],
        bio: '',
        interests: ['hiking', 'cooking', 'traveling'],
        isOnline: true,
        occupation: '',
        education: '',
        difficulty: 5,
      );

      double compatibility = t1.calculateCompatibility(t2);

      expect(compatibility, 130.0);
    });
  });
}
