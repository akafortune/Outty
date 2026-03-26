import 'package:flutter/material.dart';
import 'package:outty/features/matching/models/badge.dart' as custom_badge;
import 'package:outty/features/matching/models/exclusive_content.dart';
import 'package:outty/features/matching/models/match_criteria.dart';
import 'package:outty/features/matching/models/match_result.dart';
import 'package:outty/features/matching/repositories/matching_repository.dart';
import 'package:outty/features/profile/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchingProvider extends ChangeNotifier {
  final MatchingRepository _repository;
  ProfileProvider? _profileProvider;
  DateTime? _premiumStartDate;
  static const String _premiumStartDateKey = 'premium_start_date';
  List<ExclusiveContent> _exclusiveContent = [];
  bool _isLoadingContent = false;

  MatchCriteria _criteria = MatchCriteria();
  List<MatchResult> _matches = [];
  bool _isLoading = false;
  MatchResult? _currentProfile;
  String? _error;
  int _currentMatchIndex = 0;
  bool get isIncognitoMode => _criteria.incognitoMode;
  bool get hasMatches => matches.isNotEmpty;

  MatchingProvider({required MatchingRepository repository})
    : _repository = repository {
    _loadSavedCriteria();
    _fetchMatches();
    _loadExclusiveContent();
  }

  void setProfileProvider(ProfileProvider provider) async {
    _profileProvider = provider;
    if (provider.isPremium) {
      await _loadPremiumStartDate();
    }
    notifyListeners();
  }

  Future<void> _loadPremiumStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_premiumStartDateKey);

    if (dateString == null) {
      _premiumStartDate = DateTime.now();
      await prefs.setString(
        _premiumStartDateKey,
        _premiumStartDate!.toIso8601String(),
      );
    } else {
      _premiumStartDate = DateTime.parse(dateString);
    }
    notifyListeners();
  }

  int get _monthsSubscribed {
    if (_premiumStartDate == null) return 0;

    final now = DateTime.now();
    final difference = now.difference(_premiumStartDate!);
    return (difference.inDays / 30).floor();
  }

  bool get isPremiumUser => _profileProvider?.isPremium ?? false;

  MatchCriteria get criteria => criteria;
  List<MatchResult> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => error;
  int get currentMatchIndex => _currentMatchIndex;
  MatchResult? get currentMatch =>
      _matches.isNotEmpty && _currentMatchIndex < matches.length
      ? _matches[_currentMatchIndex]
      : null;

  void _fetchMatches() async {
    try {
      _matches = await _repository.getMatches(_criteria);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MatchResult?> fetchProfileById(String matchId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _repository.getMatchById(matchId);
      _currentProfile = profile;
      _isLoading = false;
      notifyListeners();
      return profile;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void _loadSavedCriteria() {}

  Future<void> toggleIncognitoMode(bool value) async {
    if (isPremiumUser) {}
  }

  Future<MatchResult?> nextMatch() async {
    notifyListeners();
    if (matches.isNotEmpty) {
      try {
        _currentMatchIndex++;
        final profile = await _repository.getMatchById(
          matches[currentMatchIndex].id,
        );
        _currentProfile = profile;
        _isLoading = false;
        notifyListeners();
        return profile;
      } catch (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } else if (_matches.isEmpty) {
      _fetchMatches();
      return null;
    }
  }

  void previousMatch() {
    if (_matches.isNotEmpty) {
      _currentMatchIndex--;
      notifyListeners();
    }
  }

  Future<void> likeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.likeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  Future<void> dislikeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.dislikeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  Future<void> superLikeCurrentProfile() async {
    if (currentMatch != null) {
      await _repository.superLikeProfile(currentMatch!.id);
      nextMatch();
    }
  }

  void sortMatchesByDistance() {
    _matches.sort((a, b) => a.distanceValue.compareTo(b.distanceValue));
    _currentMatchIndex = 0;
    notifyListeners();
  }

  void refreshMatches() {
    notifyListeners();
  }

  void clearProfile() {
    _currentProfile = null;
    _error = null;
    notifyListeners();
  }

  List<custom_badge.Badge> getPremiumBadges() {
    if (!isPremiumUser) {
      return [];
    }

    return custom_badge.Badge.getBadgesForDuration(_monthsSubscribed);
  }

  List<ExclusiveContent> get availableExclusiveContent {
    if (!isPremiumUser) return [];
    return _exclusiveContent
        .where((content) => _monthsSubscribed >= content.requiredMonths)
        .toList();
  }

  Future<void> _loadExclusiveContent() async {
    _isLoadingContent = true;
    notifyListeners();

    try {
      _exclusiveContent = await _repository.getExclusiveContent();
      _isLoadingContent = false;
      notifyListeners();
    } catch (e) {
      _isLoadingContent = false;
      _error = 'Failed to load exclusive content: $e';
      notifyListeners();
    }
  }

  ExclusiveContent? getContentById(String id) {
    return _exclusiveContent.firstWhere(
      (content) => content.id == id,
      orElse: () => throw Exception('Content not found'),
    );
  }
}
