enum MatchStatus {
  pending,
  matched,
  rejected,
  expired;

  String get displayName {
    switch (this) {
      case MatchStatus.pending:
        return 'Pending';
      case MatchStatus.matched:
        return 'Matched';
      case MatchStatus.rejected:
        return 'Rejected';
      case MatchStatus.expired:
        return 'Expired';
      default:
        return 'Pending';
    }
  }

  static MatchStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'Pending':
        return MatchStatus.pending;
      case 'Matched':
        return MatchStatus.matched;
      case 'Rejected':
        return MatchStatus.rejected;
      case 'Expired':
        return MatchStatus.expired;
      default:
        return MatchStatus.pending;
    }
  }

  bool get isActive => this == MatchStatus.matched;
  bool get isPending => this == MatchStatus.pending;
}
