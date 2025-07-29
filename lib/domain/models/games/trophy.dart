enum TrophyType {
  bronze,
  silver,
  gold,
  platinum,
}
class Trophy {
  final String id;
  final String name;
  final TrophyType type;
  final String detail;
  final String iconUrl;
  final bool isEarned;
  final bool isHidden;
  final DateTime? earnedDate;

  Trophy({
    required this.id,
    required this.name,
    required this.type,
    required this.detail,
    required this.iconUrl,
    required this.isEarned,
    required this.isHidden,
    this.earnedDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Trophy &&
        other.id == id;

  }
}