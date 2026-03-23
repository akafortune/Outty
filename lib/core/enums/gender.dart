enum Gender {
  male,
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      default:
        return 'Male';
    }
  }

  static Gender fromString(String value) {
    switch (value.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.male;
    }
  }

  static List<String> get displayNames => [
    Gender.male.displayName,
    Gender.female.displayName,
  ];
}
