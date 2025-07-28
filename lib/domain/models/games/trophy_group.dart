class TrophyCountInfo {
  final String type;
  final int total;
  final int earned;

  TrophyCountInfo({
    required this.type,
    required this.total,
    required this.earned,
  });
}
class TrophyGroup {
  final String id;
  final String name;
  final String detail;
  final String iconUrl;
  final List<TrophyCountInfo> trophyCountInfo;

  TrophyGroup({
    required this.id,
    required this.name,
    required this.detail,
    required this.iconUrl,
    required this.trophyCountInfo,
  });

  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrophyGroup &&
        other.id == id;
  }
}