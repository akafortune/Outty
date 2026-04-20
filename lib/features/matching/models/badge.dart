import 'package:flutter/material.dart';

class Badge {
  final String name;
  final String icon;
  final String description;
  final int requiredMonths;
  final Color color;
  final bool isPremium;

  const Badge({
    required this.name,
    required this.icon,
    required this.description,
    required this.requiredMonths,
    required this.color,
    this.isPremium = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': 'icon.codePoint',
      'description': description,
      'requiredMoths': requiredMonths,
      'color': color.value,
      'isPremium': isPremium,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      name: map['name'],
      icon: map['icon'],
      description: map['description'] ?? '',
      requiredMonths: map['requiredMonths'] ?? 0,
      color: Color(map['color'] ?? Colors.blue.value),
      isPremium: map['isPremium'] ?? true,
    );
  }

  static List<Badge> getBadgesForDuration(int monthsSubscribed) {
    return allBadges
        .where((badge) => monthsSubscribed >= badge.requiredMonths)
        .toList();
  }

  static const List<Badge> allBadges = [
    Badge(
      name: 'New Premium',
      icon: '',
      description: 'Welcome to Premium!',
      requiredMonths: 0,
      color: Colors.blue,
    ),
    Badge(
      name: 'Premium Explorer',
      icon: '',
      description: '1 month of premium experience',
      requiredMonths: 1,
      color: Colors.green,
    ),
    Badge(
      name: 'Premium Veteran',
      icon: '',
      description: '3 months of premium experience',
      requiredMonths: 3,
      color: Colors.amber,
    ),
    Badge(
      name: 'Premium Elite',
      icon: '',
      description: '6 months of premium experience',
      requiredMonths: 6,
      color: Colors.purple,
    ),
    Badge(
      name: 'Premium Legend',
      icon: '',
      description: '1 year of premium experience',
      requiredMonths: 12,
      color: Colors.red,
    ),
  ];
}
