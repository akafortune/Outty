import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';

class OnboardingProvider extends ChangeNotifier{
  final OnboardingRepository _repository;

  OnboardingProvider({
    required OnboardingRepository repository,
  }) : _repository = repository;

  String _name = '';
  String _bio = '';
  DateTime? _birthDate;
  String _gender = '';
  List<String> _interests = [];
  List<String> _photos = [];
  bool _locationPermissionGranted = false;

  String get name =>_name;
  String get bio => _bio;
  DateTime? get birthDate => _birthDate;
  String get gender => _gender;
  List<String> get interests => _interests;
  List<String> get photos => _photos;
  bool get locationPermissionGranted => _locationPermissionGranted;

  var db = FirebaseFirestore.instance;

  void updateName(String name){
    _name = name;
    notifyListeners();
  }

  void updateBio(String bio){
    _bio = bio;
    notifyListeners();
  }

  void updateBirthDate(DateTime date){
    _birthDate = date;
    notifyListeners();
  }

  void updateGender(String gender){
    _gender = gender;
    notifyListeners();
  }

  void toggleInterest(String interest){
    if(_interests.contains(interest)){
      _interests.remove(interest);
    }else {
      _interests.add(interest);
    }

    notifyListeners();
  }

  void addPhoto(String photoUrl){
    _photos.add(photoUrl);
    notifyListeners();
  }

  void removePhoto(String photoUrl){
    _photos.remove(photoUrl);
    notifyListeners();
  }

  void setLocationPermission(bool granted){
    _locationPermissionGranted = granted;
    notifyListeners();
  }

  void addPhotos(List<String> photoUrls){
    _photos.addAll(photoUrls);
    notifyListeners();
  }

  Future<void> saveOnboardingData() async{
    await _repository.saveUserData({
      'name' : _name,
      'bio' : _bio,
      'birthDate' : _birthDate?.toIso8601String(),
      'gender' : _gender,
      'interests' : _interests,
      'photos' : _photos,
      'locationPermissionGranted' : _locationPermissionGranted,
    });

    await commitOnboardingData();
  }

  Future<void> commitOnboardingData() async{
    final interestString = interestsToString();
    final photoString = photosToString();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user!.uid;


    final userStr = <String, dynamic>{
      "name" : _name,
      "bio" : _bio,
      "birthdate" : birthDate,
      "gender" : gender,
      "interests" : interestString,
      "photos" : photoString,
      "userID" : uid,
      "likes" : [],
      "dislikes" : [],
      "matches" : [],
    };

    db.collection("Users").add(userStr);
  }


  String interestsToString(){
    String interestString = "";
    for(int i = 0; i < interests.length; i++){
      interestString += interests[i];
      interestString += ",";
    }
    return interestString;
  }

  String photosToString(){
    String photoString = "";
    for(int i = 0; i < photos.length; i++){
      photoString += photos[i];
      photoString += ",";
    }
    return photoString;
  }
}