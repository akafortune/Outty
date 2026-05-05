import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/util/environment.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as u;

class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;

  OnboardingProvider({required OnboardingRepository repository})
    : _repository = repository;

  String _name = '';
  String _bio = '';
  DateTime? _birthDate;
  String _gender = '';
  List<String> _interests = [];
  List<Uint8List> _photos = [];
  List<String> _photoURLs = [];
  bool _locationPermissionGranted = false;
  int _difficulty = 0;
  String _instagramUsername = '';

  String get name => _name;
  String get bio => _bio;
  DateTime? get birthDate => _birthDate;
  String get gender => _gender;
  List<String> get interests => _interests;
  List<Uint8List> get photos => _photos;
  List<String> get photoURLs => _photoURLs;
  bool get locationPermissionGranted => _locationPermissionGranted;
  int get difficulty => _difficulty;

  var db = FirebaseFirestore.instance;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateDifficulty(int difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void updateBirthDate(DateTime date) {
    _birthDate = date;
    notifyListeners();
  }

  void updateGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void updateInstagramUsername(String username) {
    _instagramUsername = username;
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (_interests.contains(interest)) {
      _interests.remove(interest);
    } else {
      _interests.add(interest);
    }

    notifyListeners();
  }

  void addPhoto(XFile photo) async {
    final supabase = u.Supabase.instance.client;

    final photoPath = photo.path.split("/").last;

    final Uint8List fileBytes = await photo.readAsBytes();

    await supabase.storage.from('Images').uploadBinary(photoPath, fileBytes);

    _photos.add(fileBytes);
    _photoURLs.add(photoPath);
    notifyListeners();
  }

  void removePhoto(String photoUrl) {
    _photos.remove(photoUrl);
    notifyListeners();
  }

  void setLocationPermission(bool granted) {
    _locationPermissionGranted = granted;
    notifyListeners();
  }

  void addPhotos(List<Uint8List> photos) {
    _photos.addAll(photos);
    notifyListeners();
  }

  Future<void> saveOnboardingData() async {
    await _repository.saveUserData({
      'name': _name,
      'bio': _bio,
      'birthDate': _birthDate?.toIso8601String(),
      'gender': _gender,
      'difficulty': difficulty,
      'interests': _interests,
      'photos': _photoURLs,
      'locationPermissionGranted': _locationPermissionGranted,
      'instagramUsername': _instagramUsername,
    });

    await commitOnboardingData();
  }

  Future<void> commitOnboardingData() async {
    final interestString = interestsToString();
    final photoString = photosToString();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user!.uid;

    final userStr = <String, dynamic>{
      "name": _name,
      "bio": _bio,
      "birthdate": birthDate,
      "gender": gender,
      "interests": interestString,
      "photos": photoString,
      'difficulty': difficulty,
      "userID": uid,
      "instagramUsername": _instagramUsername,
      "likes": [],
      "dislikes": [],
      "matches": [],
    };

    db.collection("Users").add(userStr);
  }

  String interestsToString() {
    String interestString = "";
    for (int i = 0; i < interests.length; i++) {
      interestString += interests[i];
      interestString += ",";
    }
    return interestString;
  }

  String photosToString() {
    String photoString = "";
    for (int i = 0; i < photoURLs.length; i++) {
      photoString += photoURLs[i];
      photoString += ",";
    }
    return photoString;
  }
}
