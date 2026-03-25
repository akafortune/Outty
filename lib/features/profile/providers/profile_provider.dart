import 'package:flutter/foundation.dart';
import 'package:outty/features/profile/models/profile_details.dart';
import 'package:outty/features/profile/models/profile_photo.dart';
import 'package:outty/features/profile/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileDetails? _profile;
  List<ProfilePhoto> _photos = [];
  bool _isLoading = false;
  String? _error;

  ProfileProvider({required ProfileRepository repository})
    : _repository = repository {
    _loadUserProfile();
  }

  ProfileDetails? get profile => _profile;
  List<ProfilePhoto> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get error => error;
  bool get isPremium => _profile?.isPremium ?? false;

  Future<void> _loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _repository.getUserProfile('current_user');
      _photos = await _repository.getUserPhotos('current_user');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileDetails updatedProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateProfile(updatedProfile);
      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePhotos(List<ProfilePhoto> updatedPhotos) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updatePhotos(updatedPhotos);
      _photos = updatedPhotos;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePreferences(Map<String, bool> preferences) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_profile != null) {
        final updatedProfile = _profile!.copyWith(preferences: preferences);
        await _repository.updatePreferences(preferences);
        _profile = updatedProfile;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> upgradeToPremium() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.upgradeToPremium();
      if (_profile != null) {
        _profile = _profile!.copyWith(isPremium: true);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }
}
